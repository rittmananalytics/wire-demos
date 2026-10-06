{% docs customer_pk %}
Surrogate key for the customer, built from the Shopify customer ID.
{% enddocs %}

{% docs customer_fk %}
Foreign key to the customer dimension. Matches customer_pk in wh_core__customer_dim.
{% enddocs %}

{% docs customer_natural_key %}
Shopify customer ID, as held in Shopify.
{% enddocs %}

{% docs customer_email %}
Customer email address.
{% enddocs %}

{% docs customer_first_name %}
Customer first name.
{% enddocs %}

{% docs customer_last_name %}
Customer last name.
{% enddocs %}

{% docs customer_country_code %}
Two-letter ISO country code of the customer.
{% enddocs %}

{% docs customer_lifetime_order_count %}
Number of orders the customer has placed.
{% enddocs %}

{% docs customer_lifetime_revenue_amount %}
Total value of the customer's orders, in order currency.
{% enddocs %}

{% docs has_marketing_consent %}
True if the customer has agreed to receive marketing.
{% enddocs %}

{% docs has_customer_marketing_consent %}
True if the ordering customer has agreed to receive marketing.
{% enddocs %}

{% docs customer_created_ts %}
When the customer record was created in Shopify (UTC).
{% enddocs %}

{% docs customer_updated_ts %}
When the customer record was last updated in Shopify (UTC).
{% enddocs %}

{% docs order_pk %}
Surrogate key for the order, built from the Shopify order ID.
{% enddocs %}

{% docs order_natural_key %}
Shopify order ID, as held in Shopify.
{% enddocs %}

{% docs order_number %}
Order number shown to the customer, for example ACM-1001.
{% enddocs %}

{% docs order_email %}
Email address given with the order.
{% enddocs %}

{% docs order_payment_status %}
Shopify payment status of the order: paid or refunded.
{% enddocs %}

{% docs order_currency_code %}
Three-letter ISO currency code of the order.
{% enddocs %}

{% docs order_market %}
Shopify market the order was placed in, for example uk.
{% enddocs %}

{% docs order_total_amount %}
Total order value, in order currency.
{% enddocs %}

{% docs order_created_ts %}
When the order was placed (UTC).
{% enddocs %}

{% docs order_updated_ts %}
When the order was last updated in Shopify (UTC).
{% enddocs %}
