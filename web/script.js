var typevip = ''
var idplayer = ''
let nameplayer = '' 
let list = "";

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


function quit() {
	$('.adminpanel').fadeOut(300);
    $('.panelnovip').fadeOut(300);
	$.post('https://fly_vipsystemv2/NUIFocusOff', JSON.stringify({}));
    listVip.splice(0);
}

document.onkeyup = function (data) {
    if (data.which == 27) {
       quit();
    }
};

let listVip = []
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


function redirect(){
    var link = 'https://discord.gg/ZME2MjD8D6'
    window.invokeNative('openUrl', link)
}


let refresh = function(id, code, ident, vip, car, ped, money,){
    let vipL = new Vips(id, code, ident, vip, car, ped, money);
    listVip.push(vipL);
    showList()
}

function dc(element) {
    element.style.color = "lightblue";
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
        "<td style='color:white;'>" + p.getPed + "</td>" +
        "<td style='color:white;'>" + p.getMoney + "</td>" +
        "</tr>" +
        "<tr>" +
        "</tbody>" +
        "</table>"
    });
    act.innerHTML = (ht) + (list);
  }
  
var show = false
  function ShowElement(element){
    if (show == false){
        var elementhidden = document.getElementById(element)
        elementhidden.style.display='block'
    }else{
        elementhidden.style.display='none'
    }
  }