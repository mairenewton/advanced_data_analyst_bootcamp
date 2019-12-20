view: session_event_facts {
  derived_table: {
    explore_source: events {
      column: event_type {}
      column: created_time {}
      column: session_id {}
      column: user_identifier {}
      derived_column: session_start {
        sql:  FIRST_VALUE (created_at) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_start;;
      }
      derived_column: session_end {
        sql: LAST_VALUE (created_at) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_end;;
      }
      derived_column: session_landing_page {
        sql: FIRST_VALUE (event_type) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_landing_page;;
      }
      derived_column: session_exit_page{
        sql: LAST_VALUE (event_type) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_exit_page ;;
      }
      bind_filters: {
        from_field: session_event_facts.session_start_date
        to_field:  events.created_time
      }
    }
  }
  dimension: session_id {}
  dimension: user_identifier {}
  dimension: event_type {}
  dimension: created_time {
    type: date_time
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }
  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
  }

}
