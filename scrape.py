import requests
import json
import time

open("./out.json", "w").write('[')
new_results = []
pages = [0, 1,2,3,4,5,6,7]
while len(pages) > 0:
    x = pages.pop()
    print("Scrapping page " + str(x))

    data = '''{"query":"{        locations(page: '''+str(x)+'''){          info {            count            pages            __typename          }         results {           id          name          dimension          type          residents {            id            episode {              id            }          }        }        }      }"}'''
    headers = {
        "content-type": "application/json"
    }
    r = requests.post("https://rickandmortyapi.graphcdn.app/", data=data, headers=headers)
    results = json.loads(r.text)["data"]["locations"]["results"]


    for result in results:

        result_episodes = 0
        for resident in result["residents"]:
            for episodes in resident["episode"]:
                result_episodes = result_episodes + 1
        result_object = {
            "id": result["id"],
            "name": result["name"],
            "type": result["type"],
            "dimension": result["dimension"],
            "residents_episodes_count": result_episodes,
        }
        open("./out.json", "a").write(json.dumps(result_object, indent=2)+",")
        time.sleep(1)


    time.sleep(2)


open("./out.json", "a").write(']')
