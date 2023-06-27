const createTravelButton = document.querySelector("#create-travel-button")
const travelPlanInput = document.querySelector("#travel-plan-input")
const resultsBox = document.querySelector("#results")

function setCreateTravelError(error){
	resultsBox.innerHTML = `<div class="error">${error}</div>`
	setTimeout(()=> {
		resultsBox.innerHTML = ""
	}, 5000)
}

function setCreateTravelSuccess(){
	resultsBox.innerHTML = `<div class="error">Plano de viagem criado com sucesso!</div>`

	setTimeout(()=> {
		resultsBox.innerHTML = ""
	}, 5000)
}

function createTravel(){

  const travelStops = getSelectedIds();

	if(travelStops.length < 1 ){
		return sendAlert("error", "Selecione pelo menos 1 local")
	}

	const travel_stops = travelStops.filter((i)=> !isNaN(i)).map((value)=>Number(value))
	const requestData = { travel_stops }

	$.ajax({
		method: "POST",
		url: "/travel_plans",
		data: JSON.stringify(requestData),
		contentType: "application/json",
		dataType: 'json',
		success: (data)=> {
			console.log(data)
			window.location.href = "/travel_plan/" + data.id;
		}
	})
	$("#create-travel-button").prop("disabled",true);


}


const selectedTravelStopIds = document.querySelector("#selected-travel-stop-ids")

function selectItem( travelStopId){
  const item = document.querySelector(`#location-${travelStopId}`)
  item.className = "location-item location-selected";
}
function unSelectItem( travelStopId){
  const item = document.querySelector(`#location-${travelStopId}`)
  item.className = "location-item";
}

function getSelectedIds(){

  const selected = [];
  const locationItems = document.querySelectorAll(".location-item")


  console.log(locationItems)

  for (var i = 0; i < locationItems.length; i++) {
    const locationItem = locationItems[i];
    if(locationItem.className.includes("-selected")){
      selected.push(locationItem.getAttribute("id").replace("location-",  ""))
    }
  }

  return selected.filter(i=>isNaN(i)===false);

}

function selectLocation(id){

  if($(`#location-${id}`).attr('class').includes("location-selected")){
    unSelectItem(id);
    return  document.querySelector("#count-selected-locations").innerHTML = getSelectedIds().length
  }
  selectItem(id);
  return  document.querySelector("#count-selected-locations").innerHTML = getSelectedIds().length

}



$(document).ready(()=> {
  const travelStopLocationList = document.querySelector("#travel-stops-location-list");


  travelStopLocationList.innerHTML = "";

  	$.ajax({
  		method: "GET",
  		url: "/travel_stops",
  		dataType: 'json',
  		success: (data)=> {
        const result = data.reduce((accumulator, current) => {
          let exists = accumulator.find(item => {
            return item.id === current.id;
          });
          if(!exists) {
            accumulator = accumulator.concat(current);
          }
          return accumulator;
        }, []).sort((a,b)=> b.residents_episodes_count - a.residents_episodes_count);
  		  result.forEach((travelStop, i)=> {

            travelStopLocationList.innerHTML = travelStopLocationList.innerHTML += `<div onclick="selectLocation(${travelStop.id});" id="location-${travelStop.id}" class="location-item">
    ${i == 0 ? `<div><span class="most-popular">Mais popular</span></div>`:``}
  <span class="font-bold">${travelStop.name}</span>
              <span>${travelStop.type}</span>
              <span>${travelStop.dimension}</span>

              <div class="flex flex-grow">
              </div>
              <div class="flex justify-between items-center mt-5">
                <span class="popularity-item ${travelStop.residents_episodes_count > 20 ? "high": "bad"}">${travelStop.residents_episodes_count}</span>
                <span class="item-selected-icon"></span>
              </div>
            </div>`;
        })
  		}
  	})


})

createTravelButton.addEventListener("click", createTravel);
