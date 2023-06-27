

function selectItem(travelStopId) {
  console.log(travelStopId)
  const item = document.querySelector(`#location-${travelStopId}`)
  item.className = "location-item location-selected";
}
function unSelectItem(travelStopId) {
  const item = document.querySelector(`#location-${travelStopId}`)
  item.className = "location-item";
}

function getSelectedIds() {

  const selected = [];
  const locationItems = document.querySelectorAll(".location-item")


  console.log(locationItems)

  for (var i = 0; i < locationItems.length; i++) {
    const locationItem = locationItems[i];
    if (locationItem.className.includes("-selected")) {
      selected.push(locationItem.getAttribute("id").replace("location-", ""))
    }
  }

  return selected.filter(i => isNaN(i) === false);

}

function selectLocation(id) {

  if ($(`#location-${id}`).attr('class').includes("location-selected")) {
    unSelectItem(id);
    return document.querySelector("#count-selected-locations").innerHTML = getSelectedIds().length
  }
  selectItem(id);
  return document.querySelector("#count-selected-locations").innerHTML = getSelectedIds().length

}




$(document).ready(() => {

  const travelPlanId = window.location.href.split("/")[4]
  const travelStopLocationList = document.querySelector("#travel-stops-location-list");


  travelStopLocationList.innerHTML = "";

  $.ajax({
    method: "GET",
    url: "/travel_stops",
    dataType: 'json',
    success: (data) => {
        
      const result = data.reduce((accumulator, current) => {
        let exists = accumulator.find(item => {
          return item.id === current.id;
        });
        if (!exists) {
          accumulator = accumulator.concat(current);
        }
        return accumulator;
      }, []).sort((a, b) => b.residents_episodes_count - a.residents_episodes_count);
      result.forEach((travelStop, i) => {

        travelStopLocationList.innerHTML = travelStopLocationList.innerHTML += `<div onclick="selectLocation(${travelStop.id})" id="location-${travelStop.id}" class="location-item">
    ${i == 0 ? `<div><span class="most-popular">Mais popular</span></div>` : ``}
  <span class="font-bold">${travelStop.name}</span>
              <span>${travelStop.type}</span>
              <span>${travelStop.dimension}</span>

              <div class="flex flex-grow">
              </div>
              <div class="flex justify-between items-center mt-5">
                <span class="popularity-item ${travelStop.residents_episodes_count > 20 ? "high" : "bad"}">${travelStop.residents_episodes_count}</span>
                <span class="item-selected-icon"></span>
              </div>
            </div>`;
      })
    }
  })

  $.ajax({
    method: "GET",
    url: "/travel_plans/" + travelPlanId,
    dataType: "json",
    error: () => { return window.location.href = "/" },
    success: (response) => {
      console.log(response)
      if (!response.travel_stops) {
        return window.location.href = "/"
      }
      response.travel_stops.forEach((item, i) => {
        document.querySelector(`#location-${item}`).className = "location-item location-selected";

      });
      document.querySelector("#count-selected-locations").innerHTML = document.querySelectorAll(".location-selected").length


    },
  })


})


document.querySelector("#update-travel-button").onclick = () => {
  const newTravelStops = getSelectedIds();

  if (newTravelStops.length < 1) {
    return sendAlert("error", "Selecione pelo menos 1 local ou volte para desfazer")
  }

  $.ajax({
    method: "PUT",
    url: "/travel_plans/" + window.location.href.split("/")[4], //id
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({ travel_stops: newTravelStops.map((v) => Number(v)) }),
    success: (response) => {
      window.location.href = "/travel_plan/" + window.location.href.split("/")[4];
    }

  })
}
