view: geography {
  extension: required

  dimension: city {
    sql: ${TABLE}.city ;;
    link: {
      label: "Link To An Explore"
      url: "/explore/model/explore_name?fields=view.field_1,view.field_2,&f[view.filter_1]={{ value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }


  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: latitude {
    hidden:  yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden:  yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
#}


}
