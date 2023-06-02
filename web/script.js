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
        let vipL = new Vips(event.data.id, event.data.code, event.data.ident, event.data.vip, event.data.car, event.data.ped, event.data.money);
        listVip.push(vipL);
        showList()
	}else if(event.data.action == "updatename"){
        msgConfirm(event.data.nameplayer)
    }else if(event.data.type == "hide"){
        closeMain();
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
    idplayer = document.getElementById("idd").value;
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
        document.getElementById('givevip').disabled = false;
        }
}

function checkVIP2(){
    typevip = document.getElementById("typevip2").value;
       if (typevip === 'Choose...'){
           document.getElementById('generate').disabled = true;
       } else { 
       document.getElementById('generate').disabled = false;
       document.getElementById('givevip').disabled = false;
       }
}

function Confirm(){
    $.post('https://fly_vipsystemv2/action', JSON.stringify({
        action: "checkid",
        id: idplayer
    }));
    
}

function msgConfirm(nameplayer){
     document.getElementById('info').innerHTML = 'You will grant a VIP '+typevip+' to the '+nameplayer+' with the id '+idplayer+'.';
     document.getElementById('givevipconfirm').style.display = 'block';
}

const alertPlaceholder = document.getElementById('alert')
const appendAlert = (message, type) => {
  const wrapper = document.createElement('div')
  wrapper.innerHTML = [
    `<div class="alert alert-${type} alert-dismissible" role="alert">`,
    `   <div>${message}</div>`,
    '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>',
    '</div>'
  ].join('')

  alertPlaceholder.append(wrapper)
}

const alertTrigger = document.getElementById('generate')
if (alertTrigger) {
  alertTrigger.addEventListener('click', () => {
    appendAlert('Nice, you triggered this alert message!', 'success')
  })
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






let showList = function () {
    let act = document.getElementsByClassName("table table-dark table-striped-columns")[0];
    list = "";
    let ht = "<table table-dark table-striped-columns class='table'>" +
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
      list += "<table table-dark table-striped-columns class='table'>" +
        "<tbody>" +
        "  <tr class='table-active'>" +
        " <th scope='row'>" + p.getId + "</th>" +
        "<td>" + p.getCode + "</td>" +
        "<td>" + p.getIdentifier + "</td>" +
        "<td>" + p.getViptype + "</td>" +
        "<td>" + p.getCars + "</td>" +
        "<td>" + p.getPed + "</td>" +
        "<td>" + p.getMoney + "</td>" +
        "</tr>" +
        "<tr>" +
        "</tbody>" +
        "</table>"
    });
    act.innerHTML = (ht) + (list);
  }
  