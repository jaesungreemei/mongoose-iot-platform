from flask import Flask, request, jsonify
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider

app = Flask(__name__)

# Cassandra 설정
CASSANDRA_HOSTS = ['localhost']  # Cassandra 호스트를 리스트 형태로 제공
AUTH_PROVIDER = PlainTextAuthProvider(username='mongoose', password='200305')  # 인증 정보

# Cassandra 클러스터 및 세션 초기화
cluster = Cluster(CASSANDRA_HOSTS, auth_provider=AUTH_PROVIDER)
session = cluster.connect('iot_platform')  # 사용할 keyspace 지정

@app.route('/api/data/query', methods=['GET'])
def data_query():
    machines = request.args.get('machines', 'all')
    date = request.args.get('date')
    start_time = request.args.get('start_time')
    end_time = request.args.get('end_time')
    columns = request.args.get('columns', 'all')

    if not date:
        return jsonify({'error': 'Missing required parameter: date'}), 400

    query_columns = columns if columns != 'all' else "*"
    
    base_query = f"SELECT {query_columns} FROM your_table_name WHERE day = %s"
    query_conditions = []
    params = [date]

    if machines != 'all':
        machine_list = machines.split(',')
        query_conditions.append(f"machine IN ({','.join(['%s']*len(machine_list))})")
        params.extend(machine_list)

    if start_time and end_time:
        query_conditions.append("time >= %s AND time <= %s")
        params.extend([start_time, end_time])

    if query_conditions:
        base_query += " AND " + " AND ".join(query_conditions) + " ALLOW FILTERING"

    statement = SimpleStatement(base_query, fetch_size=None)
    rows = session.execute(statement, params)

    data = [{
        column: getattr(row, column)
        for column in query_columns.split(', ') if column != '*'
    } for row in rows]

    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
