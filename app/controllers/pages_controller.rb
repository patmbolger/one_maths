class PagesController < ApplicationController

  def download
      send_file(
      "#{Rails.root}/questions_list.tex",
      filename: "questions_list.tex",
      type: "application/pdf"
    )
  end

  def home
    redirect_to '/'
  end

  def about
  end

  def faq
  end

  def blog
  end

  def contact
  end

  def list_start
    start = '\documentclass{article}' + "\n"
    start += '\usepackage[fleqn]{amsmath}'+ "\n"
    start += '\usepackage{scrextend}'+ "\n"
    start += '\usepackage{amsmath,amssymb}'+ "\n"
    start += '\changefontsizes[12pt]{8pt}'+ "\n"
    start += '\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}'+ "\n"
    start += '\pagenumbering{gobble}'+ "\n"
    start += '\usepackage{fancyhdr}'+ "\n"
    start += '\renewcommand{\headrulewidth}{0pt}'+ "\n"
    start += '\pagestyle{fancy}'+ "\n"
    start += '\lfoot{\textcopyright\, One Maths Limited}'+ "\n"
    start += '\rfoot{}'+ "\n"
    start += '\begin{document}'+ "\n"
    start
  end

  def questions_list
    start = list_start
    end_doc = '\end{document}'
    if can? :create, Question
      text_content = ""
      Course.all.each do |course|
        text_content += '\noindent\Huge{\textbf{' + course.name + '}}\\\\[5pt]' + "\n"
        text_content += '\noindent\large{' + course.description + '}\\\\[20pt]' + "\n"
        course.units.each_with_index do |unit,unit_i|
          text_content += '\noindent\huge{\textbf{' + "Unit #{unit_i + 1} " + unit.name + '}}\\\\[18pt]' + "\n"
          unit.topics.each_with_index do |topic,topic_i|
            text_content += '\noindent\huge{\textbf{' + "Chapter #{topic_i + 1} " + topic.name + '}}\\\\[15pt]' + "\n"
            topic.lessons.each_with_index do |lesson,lesson_i|
              text_content += '\noindent\large{\textbf{' + "Lesson #{lesson_i + 1} " + lesson.name + '}}\\\\[12pt]' + "\n"
              lesson.questions.each_with_index do |question,question_i|
                text_content += question_latex(question,question_i)
              end
            end
            text_content += '\\\\[2pt]' + "\n"
            text_content += '\noindent\large{\textbf{' + "End of Chapter Questions" + '}}\\\\[15pt]' + "\n"
            topic.questions.each_with_index do |question,question_i|
            end
          end
        end
      end

      text_content += '\noindent\Huge{\textbf{' + 'Unused Questions' + '}}\\\\[10pt]' + "\n"
      text_content += '\noindent\large{}\\\\'
      Question.unused.each_with_index do |question,question_i|
        text_content += question_latex(question,question_i)
      end

      File.open('questions_list.tex', 'w') do |f|
        f.puts start
        f.puts text_content
        f.puts end_doc
      end
    end
    redirect_to '/download'
  end

  def question_latex(question,question_i)
    text_content = ""
    text_content += "\\noindent\\textbf{Question #{question_i+1}}"
    text_content += "\\hspace{20pt}Experience: #{question.experience}"
    text_content += "\\hspace{20pt}Order: #{question.order}"
    text_content += "\\hspace{20pt}Level: #{question.order}"
    text_content += "\\hspace{20pt}Question-ID: #{question.id}"
    text_content += "\\\\[2pt]\n"
    text_content += question.question_text

    tail = ""
    (1..6).each do |n|
      tail += text_content[n*-1]
    end

    if tail == "}*ngil"
      # text_content += '\\\\[4pt]'
    else
      text_content += '\\\\[4pt]'
    end

    text_content += "\n"
    text_content += "\\noindent\\textbf{Solution #{question_i+1}}\\\\[2pt]\n"

    head = question.solution.slice(0,14)
    if head == '\begin{align*}'
      text_content += '\\\\[-35pt]'
    end


    text_content += question.solution

    tail = ""
    (1..6).each do |n|
      tail += text_content[n*-1]
    end

    if tail == "}*ngil"
      # text_content += '\\\\[4pt]'
    else
      text_content += '\\\\[4pt]'
    end


    # text_content += '\\\\[4pt]'
    text_content += "\n"



    question.choices.each_with_index do |choice,choice_i|
      text_content += "Choice #{choice_i+1}: \\hspace{20pt}#{choice.content}" + "\\hspace{20pt}#{choice.correct}"
      text_content += "\\\\" + "\n"
    end

    # text_content += "\\\\[4pt]" + "\n"

    question.answers.each_with_index do |answer,answer_i|
      text_content += "Answer part #{answer_i+1}: \\hspace{10pt}Label\\hspace{10pt}#{answer.label}" + "\\hspace{10pt}Solution\\hspace{10pt}#{answer.solution}"
      text_content += "\\\\" + "\n"
      text_content += "Answer part #{answer_i+1} hint: \\hspace{15pt}#{answer.hint}" + "\\\\\n"
    end

    text_content += "\\\\[4pt]" + "\n"
    return text_content
  end

end
