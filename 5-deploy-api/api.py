from flask import Flask, request, jsonify
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra.query import SimpleStatement
from cassandra.query import dict_factory
import logging
from datetime import datetime

app = Flask(__name__)

# 로깅 설정
logging.basicConfig(filename='5-deploy-api/api_server.log', level=logging.DEBUG)

# Cassandra 설정
CASSANDRA_HOSTS = ['localhost']  # Cassandra 호스트를 리스트 형태로 제공
AUTH_PROVIDER = PlainTextAuthProvider(username='mongoose', password='200305')  # 인증 정보

# Cassandra 클러스터 및 세션 초기화
cluster = Cluster(CASSANDRA_HOSTS, auth_provider=AUTH_PROVIDER)
session = cluster.connect('iot_platform')  # 사용할 keyspace 지정
session.row_factory = dict_factory

@app.route('/api/data', methods=['GET'])
def data_query():
    date = request.args.get('date')
    machines = request.args.get('machines', 'all')
    start_time = request.args.get('start_time')
    end_time = request.args.get('end_time')
    data_columns = request.args.get('data_columns', 'all')

    if not date:
        return jsonify({'error': 'Missing required parameter: date'}), 400
    
    date = int(date)
    if start_time:
        start_time = int(start_time)
    if end_time:
        end_time = int(end_time)

    query_values = "machine, date, time, " + data_columns if data_columns != 'all' else "*"
    #여기 머신 빼고, 아래 machine in 안에 넣기
    
    base_query = f"SELECT {query_values} FROM data_table_1 WHERE date = %s"
    query_conditions = []
    params = [date]

    if machines != 'all':
        machine_list = list(map(int, machines.split(',')))
        query_conditions.append(f"machine IN ({','.join(['%s']*len(machine_list))})")
        params.extend(machine_list)

    if start_time and end_time:
        query_conditions.append("time >= %s AND time <= %s")
        params.extend([start_time, end_time])

    if query_conditions:
        base_query += " AND " + " AND ".join(query_conditions)
        
    base_query += " ALLOW FILTERING"

    try:
        statement = SimpleStatement(base_query, fetch_size=None)
        app.logger.info(statement)
        app.logger.info(params)
        rows = session.execute(statement, params)
        
        # 데이터 후처리
        data = []
        for row in rows:
            processed_row = {}
            for key, value in row.items():
                if isinstance(value, float):
                    # 소수점을 4자리까지 반올림
                    processed_row[key] = round(value, 4)
                else:
                    processed_row[key] = value
            data.append(processed_row)
        
        return jsonify(data)
    
    except:
        return jsonify({'error': 'Invalid data columns in query. Please check your query parameters.'}), 400

@app.route('/api/machines', methods=['GET'])
def get_machines():
    current_date = datetime.now().strftime("%Y%m%d")
    query = f"SELECT DISTINCT machine, date FROM data_table_1 WHERE date = {current_date} ALLOW FILTERING"
    rows = session.execute(query)
    machines = sorted([row['machine'] for row in rows])
    return jsonify(machines)

@app.route('/api/data_columns', methods=['GET'])
def get_data_columns():
    current_date = datetime.now().strftime("%Y%m%d")
    query = f"SELECT * FROM data_table_1 WHERE date = {current_date} limit 1 ALLOW FILTERING"
    rows = session.execute(query)
    first_row = rows[0] if rows else {}
    
    excluded_columns = {'date', 'time', 'machine'}
    data_columns = [key for key in first_row.keys() if key not in excluded_columns]
    
    return jsonify(data_columns)

if __name__ == '__main__':
    app.run(DEBUG=true)
