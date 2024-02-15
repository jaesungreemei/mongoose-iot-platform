from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider

auth_provider = PlainTextAuthProvider(username='mongoose', password='200305')

# Cassandra 클러스터에 연결
cluster = Cluster(['localhost'], auth_provider=auth_provider)
session = cluster.connect()

# iot_platform 키스페이스 생성 (데이터베이스가 없는 경우)
session.execute("""
    CREATE KEYSPACE IF NOT EXISTS iot_platform
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
""")

# iot_platform 키스페이스 사용
session.set_keyspace('iot_platform')

# data 테이블 생성
session.execute("""
    CREATE TABLE IF NOT EXISTS data_table_1 (
        date int,
        time int,
        machine int,
        value1 float,
        value2 float,
        value3 float,
        value4 float,
        value5 float,
        value6 float,
        value7 float,
        value8 float,
        value9 float,
        PRIMARY KEY ((date, machine), time)
    ) WITH CLUSTERING ORDER BY (time DESC)
""")

print("Database and table setup completed successfully.")
