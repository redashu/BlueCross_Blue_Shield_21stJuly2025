SELECT employee_number, lastname, name, gender, city, job_title, department, store_location, division, age, length_service, abset_hours, business_unit
FROM public.employees;

select distinct city from public.employees where gender='M';

select avg(length_service) FROM public.employees
	where gender='M' and business_unit = 'Stores';


select gender, job_title, avg(length_service)
	FROM public.employees
		group by gender, job_title;

	
	
INSERT INTO public.employees(employee_number, lastname, name, gender, city, job_title, department, store_location, division, age, 
length_service, abset_hours, business_unit)
VALUES (999, 'Johnsson', 'Johan', 'M', 'Amsterdam', 'Scientist', 'R&D', 'Amsterdam', 'Science', 30, 3, 6, 'Science');

delete from public.employees where name='Janet';