module Main exposing (main)

import Browser
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events exposing (onClick)
import Http
import Json.Decode as D exposing (Decoder)


type alias Model =
    { attendees : List Member }


type alias Url =
    String


type alias Member =
    { name : String
    , picture : Maybe Url
    }


nameDecoder : Decoder String
nameDecoder =
    D.at [ "member", "name" ] D.string


photoDecoder : Decoder (Maybe Url)
photoDecoder =
    D.maybe <| D.at [ "member", "photo", "photo_link" ] D.string


membersDecoder =
    D.list <|
        D.map2 Member
            nameDecoder
            photoDecoder


init : flags -> ( Model, Cmd Msg )
init flags =
    ( { attendees = [] }, Cmd.none )


requestAttendance =
    Http.get
        { url = "http://localhost:8000/bla.json"
        , expect = Http.expectJson GotAttendees membersDecoder
        }


type Msg
    = GotAttendees (Result Http.Error (List Member))
    | RequestStuff


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotAttendees (Ok attendees) ->
            ( { attendees = attendees }, Cmd.none )

        GotAttendees (Err err) ->
            let
                a =
                    Debug.log "error: " err
            in
            ( model, Cmd.none )

        RequestStuff ->
            ( model, requestAttendance )


viewAttendee : Member -> Html Msg
viewAttendee a =
    H.li []
        [ H.text a.name
        , case a.picture of
            Just url ->
                H.img [ HA.src url ] []

            Nothing ->
                H.text "no picture"
        ]


view : Model -> Html Msg
view model =
    H.div []
        [ H.ul [] <| List.map viewAttendee model.attendees
        , H.button [ onClick RequestStuff ] [ H.text "request" ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
