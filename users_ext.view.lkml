include: "users.view.lkml"

view: users_ext {

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  }