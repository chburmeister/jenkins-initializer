/*** BEGIN META {
    "name" : "Say sth",
    "comment" : "example scriptler with parameter",
    "parameters" : ["WHAT_TO_SAY"],
    "core": "1.300",
    "administrator":"true",
    "authors" : [
        { name : "Christoph Burmeister", email: "chburmeister@googlemail.com"}
    ]
 } END META**/

println("hello ${WHAT_TO_SAY}")