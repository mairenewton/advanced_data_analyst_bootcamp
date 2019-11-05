view: products {
  sql_table_name: public.products ;;

  parameter: select_product_detail {
    type: unquoted
    default_value: "department"
    allowed_value: {
      value: "department"
      label: "Department"
    }
    allowed_value: {
      value: "category"
      label: "Category"
    }
    allowed_value: {
      value: "brand"
      label: "Brand"
    }
  }

  dimension: product_hiearchy {
    label_from_parameter: select_product_detail
    type: string
    sql: ${TABLE}.{% parameter select_product_detail %}
      ;;
  }


  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
      link: {
        label: "Website"
        url: "http://www.google.com/search?q={{ value | encode_uri }}"
        icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
      }

      link: {
        label: "{{value}} Analytics Dashboard"
        url: "/dashboards/694?Brand={{ value | encode_uri }}"
        icon_url: "http://www.looker.com/favicon.ico"
      }
    }



  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
