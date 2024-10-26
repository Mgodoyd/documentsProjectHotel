*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem  # Para usar Sleep

*** Variables ***
${BASE_URL}       https://hotel-gjayfhhpf9hna4eb.eastus-01.azurewebsites.net/api/v1
${USER}           admin1@miumg.edu.com  # Ajusta este valor según tu configuración
${PASSWORD}       Hotel123@  # Ajusta este valor según tu configuración
${TOKEN}          None  
${CREATED_PUEST_ID}    None  # Variable para almacenar el ID del puesto creado
${CREATED_PERSONAL_ID}  None  # Variable para almacenar el ID del personal creado

*** Test Cases ***
Obtener Token De Sesión
    [Documentation]    Iniciar sesión y obtener el token de autenticación
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${payload}=    Create Dictionary    email=${USER}    password=${PASSWORD}
    ${response}=    POST    ${BASE_URL}/login   headers=${headers}    json=${payload}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    ${token}=    Set Variable    ${response.json()['data']['jwt']}
    Log    Token generado: ${token}
    Set Suite Variable    ${TOKEN}    ${token}

Get All Puestos
    [Documentation]    Obtener todos los puestos
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${response}=    GET    ${BASE_URL}/puestos    headers=${headers}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.json()}

Create A New Puesto
    [Documentation]    Crear un nuevo puesto y almacenar su ID
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${data}=      Create Dictionary    name=Conserje26
    ${response}=  POST    ${BASE_URL}/puestos    headers=${headers}    json=${data}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    # Almacena el ID del puesto creado
    ${CREATED_PUEST_ID}=    Set Variable  ${response.json()['data']['id']}
    Log    ID del puesto creado: ${CREATED_PUEST_ID}
    Set Suite Variable    ${CREATED_PUEST_ID}    ${CREATED_PUEST_ID}

Update A Puesto
    [Documentation]    Actualizar un puesto existente usando el ID del puesto creado
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${data}=      Create Dictionary    id=${CREATED_PUEST_ID}    name=Recepto2
    ${response}=  PUT    ${BASE_URL}/puestos    headers=${headers}    json=${data}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.json()}

Get All Personals
    [Documentation]    Obtener todos los personales
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${response}=    GET    ${BASE_URL}/personals    headers=${headers}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.json()}

Create A New Personal
    [Documentation]    Crear un nuevo personal y almacenar su ID
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${rol}=       Create Dictionary    id=5b26c5c4-9e98-4049-bcc5-222ede409496
    ${hotel}=     Create Dictionary    id=bab38f8a-c8b9-457d-8223-09460687c93f
    ${data}=      Create Dictionary    rol=${rol}    hotel=${hotel}    name=UserTest1  phone=12345678    email=admin33@gmail.com    password=admin    address=villa nueva, Guatemala    role=EMPLEADO
    ${response}=  POST    ${BASE_URL}/personals    headers=${headers}    json=${data}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    # Almacena el ID del personal creado
    ${CREATED_PERSONAL_ID}=    Set Variable    ${response.json()['data']['id']}
    Log    ID del personal creado: ${CREATED_PERSONAL_ID}
    Set Suite Variable    ${CREATED_PERSONAL_ID}    ${CREATED_PUEST_ID}

Create A New Habitacion
    [Documentation]    Crear una nueva habitación
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${data}=      Create Dictionary    name=Habitación46    tipo=Simple    precio=500
    ${response}=  POST    ${BASE_URL}/habitaciones    headers=${headers}    json=${data}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.json()}

Create A New Cliente
    [Documentation]    Crear un nuevo cliente
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${data}=      Create Dictionary    role=CLIENT    nombre=Carlos Sanchez   nit=123468870    telefono=12345678    email=test75@gmail.com    direccion=zona 3 Villa Nueva
    ${response}=  POST    ${BASE_URL}/clientes    headers=${headers}    json=${data}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.json()}

Create A New Reservacion
    [Documentation]    Crear una nueva reservación
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    # Crear la estructura adecuada para cliente y habitación
    ${cliente}=    Create Dictionary    id=6cc0dffa-a976-40f3-86b1-8798667c7a9d
    ${habitacion}=    Create Dictionary    id=4f581444-2474-4847-926d-253c8e289e51
    # Crear el diccionario de datos con la estructura correcta
    ${data}=      Create Dictionary    cliente=${cliente}    habitacion=${habitacion}    fecha_entrada=2024-10-10T13:23:24    fecha_salida=2024-10-15T15:00:00    estado=reservado
    ${response}=  POST    ${BASE_URL}/reservaciones    headers=${headers}    json=${data}
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200  # Asegúrate de que el código de estado esperado es el correcto
    Log    ${response.json()}

Get All Servicios
    [Documentation]    Crear un nuevo servicio
    Sleep    3s
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${response}=  GET    ${BASE_URL}/servicios    headers=${headers}  
    Log    Response: ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.json()}
