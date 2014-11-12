# -*- coding: utf-8 -*- #

module Rouge
  module Themes
    class Sam < CSSTheme
      name 'sam'

      palette :bg_dark                => '#323f4a'
      palette :plaintext_dark         => '#C7CACE'
      palette :inherited_class_dark   => '#525e68'
      palette :function_argument_dark => '#525e68'

      palette :bg_light               => '#f0f2f4'
      palette :plaintext              => '#525E68'
      palette :comment                => '#79808A'
      palette :string                 => '#009CA6'
      palette :regexp                 => '#E4002B'
      palette :number                 => '#e74ac8'
      palette :variable               => '#00a9e0'
      palette :class                  => '#00a9e0'
      palette :function               => '#00a9e0'
      palette :builtin_constant       => '#DEB218'
      palette :user_constant          => '#ff6900'
      palette :inherited_class        => '#525e68'
      palette :function_argument      => '#525e68'
      palette :quotes                 => '#e4002b'

      palette :dark                   => '#49483e'
      palette :very_dark              => '#1e0010'

      extend HasModes

      def self.light!
        mode :dark # indicate that there is a dark variant
        mode! :light
      end

      def self.dark!
        mode :light # indicate that there is a light variant
        mode! :dark
      end

      def self.make_dark!
        style Text,                   :fg => :plaintext_dark, :bg => :bg_dark
        style Name::Builtin::Pseudo,
              Name::Builtin,
              Name::Entity,
              Name::Namespace,
              Text::Whitespace,       :fg => :plaintext_dark
      end

      def self.make_light!
        style Text,                   :fg => :plaintext, :bg => :bg_light
        style Name::Builtin::Pseudo,
              Name::Builtin,
              Name::Entity,
              Name::Namespace,
              Text::Whitespace,       :fg => :plaintext
      end

      light!

      style Comment,
            Comment::Multiline,
            Comment::Single,                  :fg => :comment, :italic => true
      style Comment::Preproc,                 :fg => :comment, :bold => true
      style Comment::Special,                 :fg => :comment, :italic => true, :bold => true
      style Error,                            :fg => :comment, :italic => true
      style Generic::Deleted,
            Generic::Inserted,                :fg => :plaintext
      style Generic::Emph,                    :fg => :very_dark, :italic => true
      style Generic::Error,
            Generic::Traceback,               :fg => :regexp
      style Generic::Heading,                 :fg => :plaintext
      style Generic::Output,                  :fg => :plaintext
      style Generic::Prompt,                  :fg => :plaintext
      style Generic::Strong,                  :bold => true
      style Generic::Subheading,              :fg => :plaintext
      style Keyword,
            Keyword::Constant,
            Keyword::Declaration,
            Keyword::Pseudo,
            Keyword::Reserved,
            Keyword::Type,                    :fg => :builtin_constant, :bold => true
      style Keyword::Namespace,
            Operator::Word,
            Operator,                         :fg => :builtin_constant, :bold => true
      style Literal::Number::Float,
            Literal::Number::Hex,
            Literal::Number::Integer::Long,
            Literal::Number::Integer,
            Literal::Number::Oct,
            Literal::Number,
            Literal::String::Escape,          :fg => :number
      style Literal::String::Backtick,
            Literal::String::Char,
            Literal::String::Doc,
            Literal::String::Double,
            Literal::String::Heredoc,
            Literal::String::Interpol,
            Literal::String::Other,
            Literal::String::Regex,
            Literal::String::Single,
            Literal::String::Symbol,
            Literal::String,                  :fg => :string
      style Name::Variable::Class,
            Name::Variable::Global,
            Name::Variable::Instance,
            Name::Variable,
            Name::Attribute,                  :fg => :variable
      style Name::Class,
            Name::Decorator,
            Name::Exception,
            Name::Function,                   :fg => :function, :bold => true
      style Name::Constant,                   :fg => :user_constant
      style Name::Builtin::Pseudo,
            Name::Builtin,
            Name::Entity,
            Name::Namespace,
            Text::Whitespace,                 :fg => :plaintext
      style Name::Label,                      :fg => :plaintext, :bold => true
      style Name::Tag,                        :fg => :plaintext
      style Text,                             :fg => :plaintext, :bg => :bg_light
    end
  end
end
