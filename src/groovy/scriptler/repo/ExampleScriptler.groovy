/*** BEGIN META {
    "name" : "Say sth",
    "comment" : "example scriptler with parameter",
    "parameters" : ["WHAT_TO_SAY"],
    "core": "1.300",
    "available" : "true",
    "nonAdministerUsing" : "true",
    "onlyMaster" : "true",
    "authors" : [
        { name : "Christoph Burmeister", email: "chburmeister@googlemail.com"}
    ]
 } END META**/

println("hello ${WHAT_TO_SAY}")