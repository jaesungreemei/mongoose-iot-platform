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
            "value1": round(row.value1, 4),
        'machine': row.machine,
        'day': row.day,
        'time': row.time,
        'value1': round(row.value1, 4),
        'value2': round(row.value2, 4),
        'value3': round(row.value3, 4),
        'value4': round(row.value4, 4),
        'value5': round(row.value5, 4),
        'value6': round(row.value6, 4),
        'value7': round(row.value7, 4),
        'value8': round(row.value8, 4),
        'value9': round(row.value9, 4)
    } for row in rows]

    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
