"""
    increment_grade(grades, bonuses, exam)

One way of apply a bonus. We simply increment the grade by one level.
"""
function increment_grade(grades, bonuses, exam)
    all_possible_grades = get_grades(exam) 

    new_grades = []
    for (grade, bonus) in zip(grades, bonuses)
        ind = findfirst(g -> g == grade, all_possible_grades)
        if ind > 1 && bonus
            push!(new_grades, all_possible_grades[ind-1])
        else
            push!(new_grades, grade)
        end
    end

    return new_grades
end
