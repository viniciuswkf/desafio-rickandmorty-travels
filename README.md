
# Rick and Morty Travels

Sistema de criação de planos de viagem baseados nas localizações presentes na API pública [Rick and Morty](rickandmortyapi.com) como proposto pela Milenio Capital no desafio de processo seletivo.


## Funções

- Criar plano de viagem
- Editar plano de viagem
- Deletar plano de viagem
- Ver planos de viagem
- Ver locais disponíveis para viagem (EXTRA)

## Documentação da API
Esta é apenas uma documentação dos endpoints, para saber mais detalhes sobre parâmetros, existe uma documentação detalhada ao rodar o servidor no endpoint `/docs`

#### Ver planos de viagem

```http
  GET /travel_plans
```
- `optimize=true` - Otimiza o plano de viagem
- `expand=true` - Expande o plano de viagem
#### Ver um plano de viagem

```http
  GET /travel_plans/:id
```
- `optimize=true` - Otimiza o plano de viagem
- `expand=true` - Expande o plano de viagem

#### Criar plano de viagem

```http
  POST /travel_plans/:id
```
| Parâmetro | Tipo     | Exemplo |
| :-------- | :------- | :-------------------------------- |
| `travel_stops`      | `Array` | [1,2,3]   |



#### Editar plano

```http
  PUT /travel_plans/:id
```
| Parâmetro | Tipo     | Exemplo |
| :-------- | :------- | :-------------------------------- |
| `travel_stops`      | `Array` | [3,2,1]   |




#### Deletar plano

```http
  DELETE /travel_plans/:id
```


#### Ver locais disponíveis (EXTRA)

```http
  GET /travel_stops
```


## Como iniciar localmente
Execute os comandos na pasta do projeto

- Normal
```bash
  crystal run src/app.cr
```

- Com docker
```bash
  docker-compose build
  docker-compose up
```


## Testes

Para executar testes basta usar o seguinte comando na pasta do projeto

```bash
  crystal spec
```


## Frontend

Para consumir a API, foi desenvolvido um frontend totalmente responsivo que é capaz de consumir todos endpoints de forma totalmente intuitiva.



![Logo](https://i.ibb.co/PM8Z8Dn/Screenshot-2023-06-23-at-17-37-28-Criar-Plano-de-Viagem-Desafio-Milenio-Capital.jpg)
![Logo](https://i.ibb.co/BNXfBtS/Screenshot-2023-06-23-at-17-36-59-Plano-de-viagem-Desafio-Milenio-Capital.jpg)
