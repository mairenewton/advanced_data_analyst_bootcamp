# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

view: session_event_facts {
  derived_table: {
    explore_source: events {
      column: created_time {}
      column: event_type {}
      column: session_id {}
      column: user_identifier {}
      derived_column: session_start {
        sql: FIRST_VALUE (created_time) OVER (PARTITION BY session_id ORDER BY created_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ;;
      }
      derived_column: session_end {
        sql: LAST_VALUE (created_time) OVER (PARTITION BY session_id ORDER BY created_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ;;
      }
      derived_column: session_landing_page {
        sql: FIRST_VALUE (event_type) OVER (PARTITION BY session_id ORDER BY created_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ;;
      }
      derived_column: session_exit_page {
        sql: LAST_VALUE (event_type) OVER (PARTITION BY session_id ORDER BY created_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ;;
      }
      bind_filters: {
        from_field: session_event_facts.session_start_date
        to_field: events.created_time
      }
    }
  }
  dimension: created_time {
    type: date_time
  }
  dimension: event_type {}
  dimension: session_id {}
  dimension: user_identifier {}

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
    }
  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
    }
  dimension: session_landing_page {}
  dimension: session_exit_page {}

}
