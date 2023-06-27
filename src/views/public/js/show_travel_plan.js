const travelStopsListBox = document.querySelector("#travel-stops-list")
const optimizeButton = document.querySelector("#optimize-button")
const normalizeButton = document.querySelector("#normalize-button")
const deleteButton = document.querySelector("#delete-travel-plan")

function getTravelPlan(id, expanded = false, optimized = false){

  let args = "";

  if(expanded && optimized){
    args = "?expand=true&optimize=true";
  }

  if(expanded && !optimized){
    args = "?expand=true";
  }

  if(!expanded && optimized){
    args = "?optimize=true";
  }

  $.ajax({
    method: "GET",
    url: "/travel_plans/" + id + args,
    dataType: 'json',
    success: (data)=> {
      if(data.status && data.status["error"]){
      	window.location.href="/";
      }
      console.log(data)
      setTravelPlanStops(data.travel_stops, expanded)
    },
    error: (err) => {
      window.location.href="/";
      console.log(err)
    }
  })
}


function setTravelPlanStops(travel_stops, expand){

  travelStopsListBox.innerHTML = "";
  document.querySelector("#count-travel-stops").innerHTML = travel_stops.length

  travel_stops.map((travelStop, index)=> {

    let newTravelPlanItem
    if(expand){
      newTravelPlanItem = `<div class="travel-stops-item">
      <span class="text-bold">${travelStop.name}</span>
      <span class="text-sm opacity-60">Dimensão: ${travelStop.dimension}</span>
      <span class="text-sm opacity-60">Tipo: ${travelStop.type}</span>
      <span class="text-sm opacity-60">ID: ${travelStop.id}</span>
      ${index < travel_stops.length -1 ? `` : `<div class="">
      <span class="success-badge">Destino final</span>
      </div>`}
      </div>`
    } else {
      newTravelPlanItem = `<div class="travel-stops-item">
      <span>Localidade #${travelStop}</span>
      </div>`
    }
    travelStopsListBox.innerHTML = travelStopsListBox.innerHTML + newTravelPlanItem
    if(index < travel_stops.length -1){

      travelStopsListBox.innerHTML = travelStopsListBox.innerHTML + ` <div class="separator-box">
      <div class="separator"></div>
      </div>`
    }


  })

}

const urlParams = new URLSearchParams(window.location.search);

const travelPlanId = window.location.href.split("/")[4]

$(document).ready(function() {
  // if(!travelPlanId){
  // 	window.location.href = "/";
  // }

  document.querySelector("#update-travel-link").setAttribute("href", `/update/${travelPlanId}`)
  document.querySelector("#button-update-plan").setAttribute("href", `/update/${travelPlanId}`)
  const optimizeData = $("#optimize-button").hasClass('selected');
  const expandData = $("#show-travel-data").is(":checked");

  getTravelPlan(travelPlanId, optimizeData, expandData);
})


optimizeButton.addEventListener("click", ()=> {


  if (normalizeButton.classList)
  normalizeButton.classList.remove("selected")
  optimizeButton.classList.add("selected")
  getTravelPlan(travelPlanId, $("#show-travel-data").is(":checked") ? true : false, true);

});


normalizeButton.addEventListener("click", ()=> {

  if (optimizeButton.classList)
  optimizeButton.classList.remove("selected")
  normalizeButton.classList.add("selected")
  getTravelPlan(travelPlanId, $("#show-travel-data").is(":checked") ? true : false, false);

});


deleteButton.addEventListener("click", ()=> {

  $.ajax({
    method: "DELETE",
    url: "/travel_plans/" + travelPlanId ,
    success: () => {
      window.location.href="/";
    }
  })
})

$('#show-travel-data').change(function() {
  const optimizeData = $("#optimize-button").hasClass('selected');

  getTravelPlan(travelPlanId,
    $("#show-travel-data").is(":checked") ? true : false,
    optimizeData
  )
})
