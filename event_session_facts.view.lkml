view: event_session_facts {
  derived_table: {
    sql:
      WITH session_facts AS (
        SELECT
           session_id
          ,COALESCE(user_id::varchar, ip_address) as identifier
          ,FIRST_VALUE (created_at) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_start
          ,LAST_VALUE (created_at) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_end
          ,FIRST_VALUE (event_type) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_landing_page
          ,LAST_VALUE  (event_type) OVER (PARTITION BY session_id ORDER BY created_at ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS session_exit_page
        FROM events
        WHERE {% condition session_start_date_range %} created_at {% endcondition %}
      )
      SELECT * FROM session_facts
      WHERE {% condition session_start_date_range %} session_start {% endcondition %}
      GROUP BY 1, 2, 3, 4, 5, 6
       ;;
  }
  filter: session_start_date_range {
    type: date
    label: "Session Start Date Range"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: identifier {
    type: string
    sql: ${TABLE}.identifier ;;
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
  }

  dimension: session_landing_page {
    type: string
    sql: ${TABLE}.session_landing_page ;;
  }

  dimension: session_exit_page {
    type: string
    sql: ${TABLE}.session_exit_page ;;
  }

  set: detail {
    fields: [
      session_id,
      identifier,
      session_start_time,
      session_end_time,
      session_landing_page,
      session_exit_page
    ]
  }
}
