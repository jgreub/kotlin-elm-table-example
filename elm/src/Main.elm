import Html exposing (..)
import Http
import Json.Decode as JD

main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL

type alias Fruit =
  { name : String
  }

type alias Model = (List Fruit)

init : (Model, Cmd Msg)
init =
  ([], getFruits)


-- UPDATE

type Msg
  = GotFruits (Result Http.Error (List Fruit))

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotFruits (Ok fruits) ->
      (fruits, Cmd.none)

    GotFruits (Err _) ->
      ([Fruit "HTTP ERROR"], Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  ul []
    (List.map drawFruit model)

drawFruit : Fruit -> Html Msg
drawFruit fruit =
  li [] [ text fruit.name ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP

getFruits : Cmd Msg
getFruits =
  Http.send GotFruits (Http.get "/fruit?name=Apple" decodeFruits)

decodeFruits : JD.Decoder (List Fruit)
decodeFruits =
  JD.list decodeFruit

decodeFruit : JD.Decoder Fruit
decodeFruit =
  JD.map Fruit
    (JD.field "name" JD.string)