"""
    increment_grade(grades, bonuses, exam)

One way of apply a bonus. We simply increment the grade by one level.
But only if the `grade` is `passed => true`.
"""
function increment_grade(grades, bonuses, exam)
    all_possible_grades = get_grades(exam) 

    grades_bonus_eligible = []
    for g in exam["grades"]
        if g["passed"]
            push!(grades_bonus_eligible, g["grade"])
        end
    end

    new_grades = []
    for (grade, bonus) in zip(grades, bonuses)
        ind = findfirst(g -> g == grade, all_possible_grades)
        if ind > 1 && bonus && grade ∈ grades_bonus_eligible
            push!(new_grades, all_possible_grades[ind-1])
        else
            push!(new_grades, grade)
        end
    end

    return new_grades
end
