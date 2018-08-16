include: "*.view"

view: users_ext {
  extends: [users]

  dimension: email {
    hidden: no
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    hidden:  no
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    hidden:  no
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    hidden: no
    sql: ${first_name} || ' ' || ${last_name} ;;
  }
}
