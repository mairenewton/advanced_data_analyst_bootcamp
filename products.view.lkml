view: products {
  sql_table_name: public.products ;;

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
      label: "Google"
      url: "https://google.com/search?q={{ value | encode_uri }}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
    }
    link: {
      label: "{{value}} Analytics Dashboard"
      url: "/dashboards/694?Brand={{ value | encode_uri}}"
      icon_url: "https://www.looker.com/favicon.ico"
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

  parameter: product_attribute_selector {
#     allowed_value: {
#       label: "Brand"
#       value: "brand"
#     }
    allowed_value: {
      label: "Department"
      value: "department"
    }
    allowed_value: {
      label: "Category"
      value: "category"
    }
    type: unquoted
  }

  dimension: attribute {
    label_from_parameter: product_attribute_selector
#     sql: ${TABLE}.{% parameter product_attribute_selector %} ;;
    sql: {% if product_attribute_selector._parameter_value == 'department' %}
          ${department}
          {% else %}
          ${category}
          {% endif %}
    ;;
  }
  filter: choose_a_category_to_compare{
    type: string
    suggest_explore: order_items
    suggest_dimension: products.category
  }

  dimension: category_comparitor {
    sql:
    CASE WHEN
    {% condition choose_a_category_to_compare %}
              ${category}
     {% endcondition %}
    THEN ${category}
    ELSE 'All other categories'
    END
    ;;
  }


  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
