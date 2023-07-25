var typevip = ''
var idplayer = ''
let nameplayer = '' 
let list = "";
let carsl = "";
var quantmoney = 0;
var moneyw = 0;
var spawnped = false
class Vips{
    constructor(id, code, identifier, viptype, cars, ped, money){
        this.id = id
        this.code = code
        this.identifier = identifier
        this.viptype = viptype
        this.cars = cars
        this.ped = ped
        this.money = money
    }

    get getId(){
        return this.id;
    }
    get getCode(){
        return this.code;
    }
    get getIdentifier(){
        return this.identifier;
    }
    get getViptype(){
        return this.viptype;
    }
    get getCars(){
        return this.cars;
    }
    get getPed(){
        return this.ped;
    }
    get getMoney(){
        return this.money;
    }

}


class UserVip{
    constructor(vip, cars, peds, money){
        this.vip = vip
        this.cars = cars
        this.peds = peds
        this.money = money
    }

    get getVip(){
        return this.vip;
    }
    get getCars(){
        return this.cars;
    }
    get getPeds(){
        return this.peds;
    }
    get getMoney(){
        return this.money;
    }
}

class Cars{
    constructor(carmodel, label, imagen){
        this.carmodel = carmodel
        this.label = label
        this.imagen = imagen
    }
    get getcarModel(){
        return this.carmodel;
    }
    get getLabel(){
        return this.label;
    }
    get getImagen(){
        return this.imagen;
    }
}

function quit() {
	$('.adminpanel').fadeOut(300);
    $('.panelnovip').fadeOut(300);
    $('.panelvip').fadeOut(300);
    $('.carspanel').fadeOut(300);
	$.post('https://fly_vipsystemv2/NUIFocusOff', JSON.stringify({}));
    listVip.splice(0);
    listCars.splice(0);
    // listpVip.splice(0)
}

function back(){
    $('.panelvip').fadeIn(300);
    $('.carspanel').fadeOut(300);
}
document.onkeyup = function (data) {
    if (data.which == 27) {
       quit();
    }
};

let listVip = []
let listpVip = []
let listCars = []
window.addEventListener('message', (event) => {
	if (event.data.type == "open_panel") {
		$('.adminpanel').fadeIn(300)
        refresh(event.data.id, event.data.code, event.data.ident, event.data.vip, event.data.car, event.data.ped, event.data.money)
    }else if(event.data.action == "updatename"){
        msgConfirm(event.data.nameplayer)
    }else if(event.data.type == "hide"){
        closeMain();
    }else if(event.data.type =="open_novip"){
        $('.panelnovip').fadeIn(300)
    }else if(event.data.type == "open_vip"){
        $('.panelvip').fadeIn(300)
        rPlayerStats(event.data.vip, event.data.cars, event.data.peds, event.data.moneyx2)
        let cars = new Cars(event.data.carmodel,event.data.carslabel, event.data.imagen)
        listCars.push(cars)
    }
	
})

function checkReason(){
let reason = document.getElementById("reason").value;
    if (reason === ''){
        document.getElementById('typevip').disabled = true;
	} else { 
	document.getElementById('typevip').disabled = false;
	}

    
}   

function checkID(){
    idplayer = document.getElementById("idplayerin").value;
    if (idplayer === ''){
        document.getElementById('typevip2').disabled = true;
	} else { 
	document.getElementById('typevip2').disabled = false;
	};
}

function checkVIP(){
     typevip = document.getElementById("typevip").value;
        if (typevip === 'Choose...'){
            document.getElementById('generate').disabled = true;
        } else { 
        document.getElementById('generate').disabled = false;
        }
}

function checkVIP2(){
    typevip = document.getElementById("typevip2").value;
       if (typevip === 'Choose...'){
           document.getElementById('givevip').disabled = true;
       } else { 
       document.getElementById('givevip').disabled = false;
       }
}

function FirstConfirm(){
    $.post('https://fly_vipsystemv2/action', JSON.stringify({
        action: "checkid",
        id: idplayer
    }));
    
}

$(document).on('click', "#givevipconfirm", function() { 
    var typevip2 = document.getElementById('typevip2').value
	$.post('https://fly_vipsystemv2/action', JSON.stringify({
		action: "givevip",
        tvip2: typevip2,
        idp: idplayer
	}));
    document.getElementById('givevipconfirm').style.display = 'none';
    document.getElementById('givevip').disabled = true;
    document.getElementById('idplayerin').value = ''
    document.getElementById('typevip2').value = 'Choose...'
    document.getElementById('info').style.display = 'none';
});


function msgConfirm(nameplayer){
    document.getElementById('info').style.display = 'block';
     document.getElementById('info').innerHTML = 'You will grant a VIP '+typevip+' to the '+nameplayer+' with the id '+idplayer+'.';
     document.getElementById('givevipconfirm').style.display = 'block';
}


$(document).on('click', "#generate", function() { 
	$.post('https://fly_vipsystemv2/action', JSON.stringify({
		action: "gencode",
        tvip: typevip
	}));
    document.getElementById('generate').disabled = true;
    document.getElementById('reason').value = ''
    document.getElementById('typevip').value = 'Choose...'
});


$(document).on('click', "#cerrar", function() { 
	$.post('https://fly_vipsystemv2/action', JSON.stringify({
		action: "close"
	}));
});
function ClaimMoney(){
    moneyw = document.getElementById("quantity").value
    if (quantmoney >= moneyw){
        $.post('https://fly_vipsystemv2/action', JSON.stringify({
            action: "withdraw",
            moneyw: parseInt(moneyw)
        }));
    }else{

    }
}
function ClaimCar(carclaimed){
    quit()
    $.post('https://fly_vipsystemv2/action', JSON.stringify({
        action: "claimcar",
        carclaimed: carclaimed
    }));
    
}

// function ModPed(id){
//     if (id.getPed != "notavailable"){
//         id.getElementById("valped").disabled = false
//         document.getElementById("btnconfirmped").innerHTML = " <button type='button' class='btn btn-success' onclick='ChangePed(\"" + id.getIdentifier+ id.getPed + "\")'>H</button>"
//     }
// }

function ChangePed(identifier, id){
    const inputPed = document.getElementById("valped-" + id).value;
    $.post('https://fly_vipsystemv2/action', JSON.stringify({
        action: "changeped",
        ident : identifier,
        ped: inputPed
    }));
    quit()
}
function redirect(){
    var link = 'https://discord.gg/ZME2MjD8D6'
    window.invokeNative('openUrl', link)
}


let refresh = function(id, code, ident, vip, car, ped, money,){
    let vipL = new Vips(id, code, ident, vip, car, ped, money);
    listVip.push(vipL);
    showList()
}

let rPlayerStats = function(vip, car, ped, money){
    console.log("si")
    let playervip = new UserVip(vip, car, ped, money)
    listpVip.push(playervip)

    let cantcars = document.getElementById("cantcars").innerHTML = car 
    if (cantcars === 0){
        document.getElementById("cantcars").style.color = "red";
        document.getElementById("btncar").disabled = true
    }else{
        document.getElementById("cantcars").style.color = "rgb(9, 230, 9);";
        document.getElementById("btncar").disabled = false
    }


    let cantmoney =  document.getElementById("cantmoney").innerHTML = money 
    document.getElementById("quantity").max = money
    if (cantmoney === 0){
        document.getElementById("btnmoney").disabled = true
    }else{
        quantmoney = money
        document.getElementById("btnmoney").disabled = false
    }
    if (ped != 'notavailable' || ped != "1"){
        document.getElementById("ped").innerHTML = ped
        document.getElementById("btnped").disabled = false
    }else{
        document.getElementById("btnped").disabled = true
    }
}

function SpawnPed(){
    btntext = document.getElementById("contpedbtn").textContent
    if (spawnped === false && btntext == "Spawn"){
        spawnped = true
        document.getElementById("contpedbtn").innerHTML = "Reset Skin"
        $.post('https://fly_vipsystemv2/action', JSON.stringify({
            action: "spawnped",
            playerped: document.getElementById("ped").textContent
        }));
    }else{
        spawnped = false
        document.getElementById("contpedbtn").innerHTML = "Spawn Ped"
        $.post('https://fly_vipsystemv2/action', JSON.stringify({
            action: "resetskin"
        }));
    }
}
function ChooseCars(){
    let cards = document.getElementsByClassName("cardscars")[0];
    $('.carspanel').fadeIn(300);
    $('.panelvip').fadeOut(300);
    carsl = "";
    listCars.forEach(c =>{
        carsl +=  
        "<div class='card' id='carscards' style='width: 18rem;'>"+
        "<img src="+c.getImagen+" class='card-img-top' alt='...'>"+
        "<div class='card-body'>"+
           " <h5 class='card-title d-flex justify-content-center' style='color:white'>"+c.getLabel+"</h5>"+
         "   <a  class='btn d-flex justify-content-center' id='btnclaim' onclick='ClaimCar(\"" + c.getcarModel + "\")'>Claim</a>"+
       " </div>"+
        "</div>"
    });
    cards.innerHTML = (carsl)
}

  
let showList = function () {
    let act = document.getElementsByClassName("table table-bordered")[0];
    list = "";
    let ht = "<table table-bordered class='table'>" +
      "<thead>" +
      "  <tr>" +
      "<th scope='col'>ID</th>" +
      "<th scope='col'>Code</th>" +
      "<th scope='col'>Identifier</th>" +
      "<th scope='col'>Vip Type</th>" +
      "<th scope='col'>Cars</th>" +
      "<th scope='col'>Ped</th>" +
      "<th scope='col'>Money</th>" +
      "<th scope='col'>Actions</th>" +
      "</tr>" +
      "</thead>" +
      "</table>"
  
      listVip.forEach(p => {
        list += "<table table-bordered class='table'>" +
          "<tbody>" +
          "  <tr class='table-active'>" +
          " <th scope='row' style='color:white;'>" + p.getId + "</th>" +
          "<td id = 'cen'>" + p.getCode +"</td>" +
          "<td style='color:white;'>" + p.getIdentifier + "</td>" +
          "<td style='color:white;'>" + p.getViptype + "</td>" +
          "<td style='color:white;'>" + p.getCars + "</td>" +
          "<td style='color:white;'>" +
          "<div class='input-container'>" +"<input type='text' style='width:80%;' id='valped-" + p.getId + "' disabled class='form-control' value='" + p.getPed + "'>" +"<a id='modped-" + p.getId + "' onclick='ModPed(" + p.getId + ")' class='btn bi bi-pencil-square'></a>" +"</div>" +
          "<span id='btnconfirmped-" + p.getId + "'></span>" +
          "</td>" +
          "<td style='color:white;'>" + p.getMoney + "</td>" +
          "<td style='color:white;'>" + "<a id='del' onclick='DeleteVip(" + p.getId + ")' class='btn bi bi-trash'></a>" +  "<span id='confirmdel-"+p.getId+"'></span>"+"</td>" 
          "</tr>" +
          "<tr>" +
          "</tbody>" +
          "</table>"
      });
      
      act.innerHTML = (ht) + (list);
      
    }
  

    function ModPed(id){
        console.log(id)
        const inputped = document.getElementById("valped-" + id);
        const btnconfirmped = document.getElementById("btnconfirmped-" + id);
        if (inputped.value !== "notavailable"){
            let search = listVip.find(v => v.getId == id)
            // console.log(search.getIdentifier)
            inputped.disabled = false;
            btnconfirmped.innerHTML = ` <button type='button' class='btn btn-success' onclick='ChangePed("${search.getIdentifier}", "${id}")'>Confirm</button>`;
        }
    }


    function DeleteVip(id){
        document.getElementById("confirmdel-"+id).innerHTML = ` <button type='button'  class='btn bi bi-check' onclick='ConfirmDel("${id}")'></button>`
    }

    function ConfirmDel(id){
        $.post('https://fly_vipsystemv2/action', JSON.stringify({
            action: "delvip",
            idvip:id
        }));
        quit()
    }

    function RedeemCode(){
       
        $.post('https://fly_vipsystemv2/action', JSON.stringify({
            action: "redeemvip",
            code:document.getElementById("code").value
        }));
        quit()
    }