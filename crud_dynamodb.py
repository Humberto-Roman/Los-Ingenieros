import boto3
from boto3.dynamodb.conditions import Key, Attr

# Inicializar el recurso. Usará automáticamente el Rol de IAM de la EC2.
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
tabla = dynamodb.Table('Vacantes')

print("--- 1. INSERTANDO DATOS ---")
items = [
    {'habilidad': 'Java', 'fecha_publicacion': '2026-10-10', 'id_vacante': 'V-001', 'empresa': 'TechSol', 'puesto': 'Desarrollador Java', 'ubicacion': 'Culiacán'},
    {'habilidad': 'SQL', 'fecha_publicacion': '2026-10-10', 'id_vacante': 'V-001', 'empresa': 'TechSol', 'puesto': 'Desarrollador Java', 'ubicacion': 'Culiacán'},
    {'habilidad': 'Python', 'fecha_publicacion': '2026-10-11', 'id_vacante': 'V-002', 'empresa': 'InnovaSoft', 'puesto': 'Programador Python', 'ubicacion': 'Los Mochis'},
    {'habilidad': 'Java', 'fecha_publicacion': '2026-10-12', 'id_vacante': 'V-003', 'empresa': 'DevMX', 'puesto': 'Programador Junior', 'ubicacion': 'Mazatlán'}
]

for item in items:
    tabla.put_item(Item=item)
    print(f"Insertado: {item['puesto']} para habilidad {item['habilidad']}")

print("\n--- 2. CONSULTANDO (Query) ---")
respuesta = tabla.query(
    KeyConditionExpression=Key('habilidad').eq('Java')
)
print("Vacantes que piden Java:")
for item in respuesta['Items']:
    print(f" - {item['empresa']}: {item['puesto']} ({item['fecha_publicacion']})")

print("\n--- 3. ACTUALIZANDO (Update) ---")
tabla.update_item(
    Key={'habilidad': 'Python', 'fecha_publicacion': '2026-10-11'},
    UpdateExpression="set ubicacion = :u",
    ExpressionAttributeValues={':u': 'Culiacán'}
)
print("Actualizada la ubicación de la vacante V-002 a Culiacán.")

print("\n--- 4. ELIMINANDO (Delete) ---")
tabla.delete_item(
    Key={'habilidad': 'Java', 'fecha_publicacion': '2026-10-12'}
)
print("Eliminada la vacante de DevMX (Java - 2026-10-12).")

print("\n--- 5. CONSULTA INEFICIENTE (Scan) ---")
respuesta_scan = tabla.scan(
    FilterExpression=Attr('empresa').eq('InnovaSoft')
)
print("Resultados del escaneo (Scan) para InnovaSoft:")
for item in respuesta_scan['Items']:
    print(f" - Encontrado: {item['puesto']}")
    
print("\n¡Operaciones completadas!")
