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

@app.route('/data', methods=['GET'])
def query_data():
    machine = request.args.get('machine')
    day = request.args.get('day')
    
    print(machine)
    print(day)

    # Cassandra에서 데이터 조회
    query = "SELECT * FROM data_table_1 WHERE machine = %s AND day = %s"
    rows = session.execute(query, (int(machine), int(day)))

    # 조회된 데이터를 JSON으로 변환
    data = [{
        'machine': row.machine,
        'day': row.day,
        'time': row.time,
        'value1': row.value1,
        'value2': row.value2,
        'value3': row.value3,
        'value4': row.value4,
        'value5': row.value5,
        'value6': row.value6,
        'value7': row.value7,
        'value8': row.value8,
        'value9': row.value9
    } for row in rows]

    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
