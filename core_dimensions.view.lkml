view: core_dimensions {
  extension: required

  dimension: one {
    hidden: yes
    sql: (select 1) ;;
  }

  dimension: two {
    sql: (select 2) ;;
  }

}
