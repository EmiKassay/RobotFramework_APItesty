*** Settings ***
Documentation  Rest Api Testing with Request Library
Library        RequestsLibrary
Library        JSONLibrary
Library        OperatingSystem

*** Variables ***
${URL}  https://jsonplaceholder.typicode.com


*** Test Cases ***
GET Request All Posts
    [Documentation]  Get Request - retrieve all posts
    GET  url=${URL}/posts  expected_status=200
    

GET Request and Parse Response Object
    [Documentation]  Retrieve all posts and parse response Object
    ${response}=    GET  url=${URL}/posts  expected_status=200  
    
        FOR    ${item}    IN    @{response.json()}
            Log To Console    ID: ${item['userId']} | Title: ${item['title']}
        END 

GET Request All Posts and save it To File
    [Documentation]  Get Request - retrieve all posts
    ${response}=   GET  url=${URL}/posts  expected_status=200
    ${json_data}=  Convert String To Json   ${response.content}
    Dump Json To File   AllPost.txt   ${json_data}   encoding=UTF8   

GET Request - filter by specific endpoint
    [Documentation]  Retrieve specific response object -by specific URI
    ${response}=    GET  url=${URL}/posts/1  expected_status=200   
    Log To Console    ID: ${response.json()['userId']} | Title: ${response.json()['title']}

GET Request - filter by GET/params argument
    [Documentation]  Retrieve all post, filter by params query
    &{params}=  Create Dictionary  id=1
    ${response}=  GET  url=${URL}/posts  expected_status=200  params=${params}
    
    FOR    ${item}    IN    @{response.json()}
          Log To Console    ID: ${item['userId']} | Title: ${item['title']}
        
    END 


PUT Request
    [Documentation]  Updating specific data with PUT 
    &{headers}=  Create Dictionary  Content-type=application/json  charset=UTF-8
    &{data}=  Create Dictionary  id=1  title=Updatujem data cez RF from SR  
    ...  body=Clovek potrebuje cloveka  userId=7
    ${response}=  PUT  url=${URL}/posts/1  json=${data}  headers=${headers}
    Log To Console    ${response.json()}

PUT Request from external Json file
    [Documentation]  Updating specific data with PUT from external file
    ${json_data}=  Load Json From File    ${CURDIR}/update.json
    &{headers}=  Create Dictionary  Content-type=application/json  charset=UTF-8
    ${response}=  PUT  url=${URL}/posts/1  json=${json_data}  headers=${headers}
    Log To Console    ${response.json()}

PATCH Request from external Json file
    [Documentation]  Updating specific data with PATCH from external file
    ${json_data}=  Load Json From File    ${CURDIR}/patch.json
    &{headers}=  Create Dictionary  Content-type=application/json  charset=UTF-8
    ${response}=  PATCH  url=${URL}/posts/1  json=${json_data}  headers=${headers}
    Log To Console    ${response.json()}

POST Request
    [Documentation]  Create DB record with POST 
    &{headers}=  Create Dictionary  Content-type=application/json  charset=UTF-8
    &{data}=  Create Dictionary  title=Pridavam data cez RF  body=Clovek potrebuje cloveka  userId=7
    ${response}=  POST  url=${URL}/posts  json=${data}  headers=${headers}  
    ...  expected_status=201
    Log To Console    ${response.json()}

Delete Request with method Delete 
    [Documentation]  Deleting record with method Delete
    ${response}=  DELETE  url=${URL}/posts/1 expected_status=200
    Log To Console    Zaznam je vymazany. ${response.json()}
