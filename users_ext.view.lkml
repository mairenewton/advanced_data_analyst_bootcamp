# To make recognize the original file

include: "users.view.lkml"

view: users_ext {
  extends: [users]
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


#dimension: gender
#hidden: yes
