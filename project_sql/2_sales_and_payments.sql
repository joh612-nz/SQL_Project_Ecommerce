/*

💡 다음 미션: 월별 매출액 구하기
orders 테이블의 order_purchase_timestamp와 order_payments 테이블의 payment_value를 합쳐서 월별 총 매출액을 구하는 쿼리를 짜보시겠어요?

힌트: 날짜에서 '월'만 추출하려면 DATE_TRUNC('month', order_purchase_timestamp) 함수를 사용하면 편리합니다.

지금 바로 두 번째 파일을 시작해 볼까요? 아니면 첫 번째 파일에서 더 궁금한 점이 있으신가요?

매출 추이: 월별 매출액(payment_value)은 성장하고 있는가?
Is payment_value increasing over time on a monthly basis?
Check the change in payment_value over time by each city

결제 수단: 브라질 사람들은 할부(payment_installments)를 얼마나 많이 하는가? (브라질은 할부 문화가 매우 발달해 있습니다.)

가격 vs 배송비: 상품 가격과 배송비(freight_value)의 비율은 어떠한가?

need to check that order status (from orders table) is 'delivered' to ensure that we are analyzing completed transactions, as other statuses like 'canceled' or 'returned' may not reflect actual sales and payments.
*/


--need to check if order years are all same or not, if not we need to consider that in our analysis of monthly sales trends.

SELECT
    orders.order_id,
    Extract(MONTH FROM orders.order_purchase_timestamp) AS order_month,
    order_payments.payment_value
FROM orders
INNER JOIN order_payments ON orders.order_id = order_payments.order_id
WHERE orders.order_status = 'delivered'
ORDER BY order_month;

-- Need to fix this query
WITH quarterly_sales AS (
    SELECT
        DATE_TRUNC('month', orders.order_purchase_timestamp) AS order_month,
        SUM(order_payments.payment_value) AS total_sales,
        CASE (
            WHEN EXTRACT(MONTH FROM orders.order_purchase_timestamp) IN (1, 2, 3) THEN 'Q1'
            WHEN EXTRACT(MONTH FROM orders.order_purchase_timestamp) IN (4, 5, 6) THEN 'Q2'
            WHEN EXTRACT(MONTH FROM orders.order_purchase_timestamp) IN (7, 8, 9) THEN 'Q3'
            ELSE 'Q4'
        END AS quarter
        )
    FROM orders
    INNER JOIN order_payments ON orders.order_id = order_payments.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY order_month
    ORDER BY order_month
)