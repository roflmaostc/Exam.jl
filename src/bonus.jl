function increment_grade(grades, bonuses, exam)
    grades = get_grades(exam) 

    new_grades = []
    for (grade, bonus) in zip(grades, bonuses)
        ind = findfirst(g -> g == grade, grades)
        if ind > 1 && bonus
            push!(new_grades, grades[ind-1])
        else
            push!(new_grades, grade)
        end
    end

    return grades
end
