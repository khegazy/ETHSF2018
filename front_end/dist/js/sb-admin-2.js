
if (document.getElementById("create_offer") !== null) {
    document.getElementById("create_offer").onclick = create_offer;
}

function create_offer() {
    document.getElementById("offer_table").innerHTML +=
        "<td>" + document.getElementById('fname').value + "</td>" +
        "<td>10/21/2018</td>" +
        "<td>" + document.getElementById('fcollateral').value + "</td>" +
        "<td>" + document.getElementById('fdate').value + "</td>"
};

if (document.getElementById("create_agreement") !== null) {
    document.getElementById("create_agreement").onclick = create_agreement;
}

function create_agreement() {
    document.getElementById("agreement_table").innerHTML +=
        "<td>" + document.getElementById('fname').value + "</td>" +
        "<td>10/21/2018</td>" +
        "<td>" + document.getElementById('fcollateral').value + "</td>" +
        "<td>" + document.getElementById('fdate').value + "</td>"
};

