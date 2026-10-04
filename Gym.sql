-- Task 8 - Gym Database SQL Queries

-- 1. اعرض أسماء كل الـ trainers الذين تخصصهم "cardio"
SELECT name ,speciality FROM trainers WHERE speciality ='cardio'; 

-- 2. اعرض أسماء وتواريخ اشتراك كل الـ members اللي اشتركوا في شهر يوليو 2024
SELECT name, start_date
FROM members
WHERE start_date BETWEEN '2024-07-01' AND '2024-07-31' ;



-- 3. ما هي أغلى خطة اشتراك (plan) موجودة، مع سعرها؟
SELECT plan_name, plan_price
FROM membership_plans
WHERE plan_price = (SELECT MAX(plan_price) FROM membership_plans);



-- 4. كام trainer لسه معندوش تخصص محدد (speciality = NULL)؟
SELECT COUNT(*) AS total_trainers FROM trainers WHERE speciality IS NULL;

-- 5. اعرض كل الـ sessions اللي بيدربها الـ trainer اللي اسمه "Diego Torres"
SELECT sessions.name, trainers.name FROM sessions JOIN trainers ON sessions.trainer_id = trainers.id WHERE trainers.name = 'Diego Torres';

-- 6. اعرض كل خطة اشتراك مع عدد الأعضاء المشتركين فيها، من الأكبر للأصغر
SELECT plans.name, COUNT(members.id) AS members_count FROM plans LEFT JOIN members ON plans.id = members.plan_id GROUP BY plans.id, plans.name ORDER BY members_count DESC;

-- 7. اعرض كل session مع إجمالي عدد الحجوزات، من الأكثر للأقل
SELECT sessions.name, COUNT(bookings.id) AS bookings_count FROM sessions LEFT JOIN bookings ON sessions.id = bookings.session_id GROUP BY sessions.id, sessions.name ORDER BY bookings_count DESC;

-- 8. اعرض أسماء الأعضاء وأرقام الـ lockers، للأعضاء المشتركين في خطة Premium فقط
SELECT members.name, lockers.locker_number FROM members JOIN plans ON members.plan_id = plans.id JOIN lockers ON members.locker_id = lockers.id WHERE plans.name = 'Premium';

-- 9. Subquery: اعرض اسم الـ trainer اللي بيدرب session اسمها "HIIT Bootcamp"
SELECT name FROM trainers WHERE id = (SELECT trainer_id FROM sessions WHERE name = 'HIIT Bootcamp');

-- 10. Subquery: اعرض كل الأعضاء اللي مشتركين في خطة أرخص من خطة Premium
SELECT name FROM members WHERE plan_id IN (SELECT id FROM plans WHERE price < (SELECT price FROM plans WHERE name = 'Premium'));

-- 11. HAVING: اعرض كل الـ sessions اللي عدد الحجوزات فيها أكتر من 4
SELECT sessions.name, COUNT(bookings.id) AS bookings_count FROM sessions JOIN bookings ON sessions.id = bookings.session_id GROUP BY sessions.id, sessions.name HAVING bookings_count > 4 ORDER BY bookings_count DESC;

-- 12. اعرض كل trainer عنده أكتر من session واحدة، مع إجمالي الحجوزات، واللي إجمالي حجوزاتهم أكتر من 10
SELECT trainers.name, COUNT(DISTINCT sessions.id) AS sessions_count, COUNT(bookings.id) AS bookings_count FROM trainers JOIN sessions ON trainers.id = sessions.trainer_id LEFT JOIN bookings ON sessions.id = bookings.session_id GROUP BY trainers.id, trainers.name HAVING sessions_count > 1 AND bookings_count > 10;

-- 13. Subquery: اعرض الـ session أو الـ sessions اللي عندها أكبر عدد حجوزات
SELECT name FROM sessions WHERE id IN (SELECT session_id FROM bookings GROUP BY session_id HAVING COUNT(*) = (SELECT MAX(bookings_count) FROM (SELECT COUNT(*) AS bookings_count FROM bookings GROUP BY session_id) AS x));

-- 14. Subquery: اعرض الـ trainer أو الـ trainers اللي بيدرب أكبر عدد sessions
SELECT name FROM trainers WHERE id IN (SELECT trainer_id FROM sessions GROUP BY trainer_id HAVING COUNT(*) = (SELECT MAX(session_count) FROM (SELECT COUNT(*) AS session_count FROM sessions GROUP BY trainer_id) AS x));

-- 15. Subquery with NOT IN: اعرض أسماء الـ sessions اللي محدش من أعضاء خطة VIP حجزها
SELECT name FROM sessions WHERE id NOT IN (SELECT session_id FROM bookings WHERE member_id IN (SELECT id FROM members WHERE plan_id = (SELECT id FROM plans WHERE name = 'VIP')));
