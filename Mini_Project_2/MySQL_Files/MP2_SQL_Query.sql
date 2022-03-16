use University;

/* 1. Produce a list of all the students in the student relation, 
 including their ID, name and department name, sorted into ascending order by their name. */
 
 select ID, `name`, dept_name 
 from student
 order by `name`;
 
 /* 2. Produce a list of the names and salaries of professors in 
 the Comp. Sci. and Elec. Eng. departments ordered by decreasing salary. */
 
 select `name`, salary
 from instructor
 where dept_name = "Comp. Sci." or dept_name = "Elec. Eng."
 order by salary desc;
 
 /* 3. Find all courses whose identifier starts with the string ”CS-1” */
 
 select *
 from course
 where course_id like "CS-1%";
 
 /* 4. Find the maximum and minimum enrollment across all sections, 
 considering only sections that had some enrollment, don’t worry about those 
 that had no students taking that section */

select course_id, sec_id, semester, `year`, 
	count(distinct ID, course_id, sec_id,semester,`year`) as students_enrolled,
    min(min_val) as min_enrollment_all, max(max_val) as max_enrollment_all
from takes, 
(
	select max(s_count) as max_val, min(s_count) as min_val
	from 
    (
		select a.course_id, a.sec_id, a.semester, a.`year`, 
			count(distinct a.ID, a.course_id, a.sec_id,a.semester,a.`year`) as s_count
		from takes a
		group by a.course_id, a.sec_id, a.semester, a.`year`
	) enrolled
) extremes
group by course_id, sec_id, semester, `year`
having Students_Enrolled = min_enrollment_all or Students_Enrolled = max_enrollment_all  
order by Students_Enrolled desc,`year`, sec_id;


/* 5.	Create a view faculty showing only the ID, name, and department of instructors */

CREATE VIEW `faculty` AS
select id, `name`, dept_name
from instructor;

SELECT * FROM faculty;

/* 6.	Create a view “CSinstructors”, showing all information about instructors from 
the Comp. Sci. department. */

CREATE VIEW `CSinstructors` AS
select id, `name`, dept_name
from instructor
where dept_name = "Comp. Sci.";

SELECT * FROM CSinstructors;
