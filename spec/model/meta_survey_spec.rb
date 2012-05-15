#encoding: utf-8
require 'spec_helper'
require 'survey_helper'
include SurveyHelper

describe MetaSurvey do
  
  before(:each) do
    @organization = Factory(:organization)
  end
  
  describe "loading a new MetaSurvey" do
    
    before(:each) do
      file = File.open File.join(Rails.root, "spec", "resources", "surveys", "survey.yml")
      MetaSurvey.register_with(:organization_id => @organization.id, :survey_descriptor_file => file)
    end
    
    it "should persist it" do
      ms = MetaSurvey.first
      ms.name.should == "Encuesta Diversa"
      ms.size.should == 200
      ms.organization.should == @organization
      ms.meta_questions.size.should == 12
    end
    
    it "should not let me register a new MetaSurvey with the same identifier" do
      file = File.open File.join(Rails.root, "spec", "resources", "surveys", "survey.yml")
      meta_survey=MetaSurvey.register_with(:organization_id => @organization.id, :survey_descriptor_file => file)
      meta_survey.errors[:identifier][0].should == I18n.t('meta_survey.validations.identifier')
      MetaSurvey.count.should == 1
    end

    it "should have registered a question with one item and two options" do
      surveyQuestionNumber="11"
      meta_question=MetaQuestion.find_by_identifier(surveyQuestionNumber)
      meta_question.title.should == "Revele su sexo arrastrando la línea de división"
      meta_question.group.should == "Género"
      meta_question.type_of.should == "SC"
      
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i1").human_value.should == "Sexo"
      
      MetaAnswerOption.find_by_identifier("#{surveyQuestionNumber}o1").human_value.should == "Masculino"
      MetaAnswerOption.find_by_identifier("#{surveyQuestionNumber}o2").human_value.should == "Femenino"
    end
    
    it "should have registered a question with the same number of items and options" do
      #formed by the survey number field and the question number
      surveyQuestionNumber="12"
      meta_question=MetaQuestion.find_by_identifier(surveyQuestionNumber)
      meta_question.title.should == "Indique qué tan de acuerdo está con los siguientes conceptos"
      meta_question.group.should == "Bici"
      meta_question.type_of.should == "LK"
      
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i1").human_value.should == "Deben construirse más avenidas para más autos"
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i2").human_value.should == "Salir en bicicleta es peligroso"
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i5").human_value.should == "La bicicleta es un medio de transporte eficiente"
      
      MetaAnswerOption.find_by_identifier("#{surveyQuestionNumber}o1").human_value.should == "Muy de acuerdo"
      MetaAnswerOption.find_by_identifier("#{surveyQuestionNumber}o2").human_value.should == "De acuerdo"
      MetaAnswerOption.find_by_identifier("#{surveyQuestionNumber}o5").human_value.should == "Muy en desacuerdo"
    end
    
    it "should have registered a question with no options" do
      #formed by the survey number field and the question number
      surveyQuestionNumber="17"
      
      meta_question=MetaQuestion.find_by_identifier(surveyQuestionNumber)
      meta_question.title.should == "Considerando la opinión que tiene respecto al precio y desempeño de las siguientes marcas de automóviles, arrastre la imagen que aparece y colóquela en el siguiente mapa"
      meta_question.group.should == "Autos"
      meta_question.type_of.should == "MOSM"
      
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i1").human_value.should == "Nissan"
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i2").human_value.should == "Audi"
      MetaAnswerItem.find_by_identifier("#{surveyQuestionNumber}i5").human_value.should == "Volkswagen"
    end
    
    it "should generate a header for the table results" do
      meta_survey = MetaSurvey.first

      meta_survey.results_frame.should include({
        :title => "P1_1", 
        :meta_question => MetaQuestion.find_by_identifier("11"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("11i1"),
        :empty_fill => false })

      meta_survey.results_frame.should include({
        :title => "P2_1",
        :meta_question => MetaQuestion.find_by_identifier("12"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("12i1"),
        :empty_fill => false })
      meta_survey.results_frame.should include({
        :title => "P2_2",
        :meta_question => MetaQuestion.find_by_identifier("12"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("12i2"),
        :empty_fill => false })
      meta_survey.results_frame.should include({
        :title => "P2_3",
        :meta_question => MetaQuestion.find_by_identifier("12"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("12i3"),
        :empty_fill => false })
      meta_survey.results_frame.should include({
        :title => "P2_4",
        :meta_question => MetaQuestion.find_by_identifier("12"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("12i4"),
        :empty_fill => false })
      meta_survey.results_frame.should include({
        :title => "P2_5",
        :meta_question => MetaQuestion.find_by_identifier("12"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("12i5"),
        :empty_fill => false })

      meta_survey.results_frame.should_not include({
        :title => "P2_6",
        :meta_question => MetaQuestion.find_by_identifier("12"), 
        :meta_answer_item => MetaAnswerItem.find_by_identifier("12i6"),
        :empty_fill => false })
    end
    
    describe "after commiting two survey results set" do
      
      before(:each) do
        commit_results(survey_results)
        commit_results(another_survey_results)
      end
      
      it "should list the result set for both surveys" do
        meta_survey = MetaSurvey.first
        
        meta_survey.merged_results[I18n.t('surveys.columns.survey.title')].should == [Survey.first.id, Survey.last.id]
        meta_survey.merged_results[I18n.t('surveys.columns.pollster.title')].should == [Survey.first.pollster.username, Survey.last.pollster.username]
        meta_survey.merged_results[I18n.t('surveys.columns.device.title')].should == [Survey.first.device.identifier, Survey.last.device.identifier]
        
        meta_survey.merged_results["P1_1"].should == [MetaAnswerOption.find_by_identifier("11o1").order_identifier, MetaAnswerOption.find_by_identifier("11o2").order_identifier]
        meta_survey.merged_results["P2_1"].should == [MetaAnswerOption.find_by_identifier("12o2").order_identifier, MetaAnswerOption.find_by_identifier("12o4").order_identifier]
        meta_survey.merged_results["P2_2"].should == [MetaAnswerOption.find_by_identifier("12o4").order_identifier, MetaAnswerOption.find_by_identifier("12o1").order_identifier]
        meta_survey.merged_results["P2_3"].should == [MetaAnswerOption.find_by_identifier("12o5").order_identifier, MetaAnswerOption.find_by_identifier("12o1").order_identifier]
        meta_survey.merged_results["P2_4"].should == [MetaAnswerOption.find_by_identifier("12o1").order_identifier, MetaAnswerOption.find_by_identifier("12o1").order_identifier]
        meta_survey.merged_results["P2_5"].should == [MetaAnswerOption.find_by_identifier("12o3").order_identifier, MetaAnswerOption.find_by_identifier("12o4").order_identifier]
        meta_survey.merged_results["P3_1"].should == ["TGV", "Audi"]
        meta_survey.merged_results["P3_2"].should == ["SNFC", "Renault"]
        meta_survey.merged_results["P3_3"].should == ["", ""]
        meta_survey.merged_results["P3_4"].should == ["", ""]
        meta_survey.merged_results["P3_5"].should == ["", ""]

        meta_survey.merged_results(:translated)["P9_1_1"].should == [1, 2]
        meta_survey.merged_results(:translated)["P9_1_2"].should == [1, 2]
        meta_survey.merged_results(:translated)["P9_1_3"].should == [2, 2]
        meta_survey.merged_results(:translated)["P9_1_4"].should == [1, 1]
        meta_survey.merged_results(:translated)["P9_2_1"].should == [1, 1]
        meta_survey.merged_results(:translated)["P9_2_2"].should == [1, 2]
        meta_survey.merged_results(:translated)["P9_2_3"].should == [2, 2]
        meta_survey.merged_results(:translated)["P9_2_4"].should == [2, 1]
        meta_survey.merged_results(:translated)["P9_3_1"].should == [1, 2]
        meta_survey.merged_results(:translated)["P9_3_2"].should == [1, 1]
        meta_survey.merged_results(:translated)["P9_3_3"].should == [2, 2]
        meta_survey.merged_results(:translated)["P9_3_4"].should == [2, 2]
      end
      
      it "should generate rows for exporting to CSV" do
        meta_survey = MetaSurvey.first
        csv_rows = meta_survey.rows_for_csv
        csv_rows.length.should == 3
        csv_rows[0].length.should == 78
        csv_rows[1].length.should == 78
        csv_rows[2].length.should == 78
      end
    end
        
  end
  
  context "should not load a survey given" do
    
    it "has questions that use the same number for it's ordering" do
      file = File.open File.join(Rails.root, "spec", "resources", "surveys", "inconsistent_survey.yml")
      meta_survey = MetaSurvey.register_with(:organization_id => @organization.id, :survey_descriptor_file => file)
      meta_survey.should_not be_persisted
      MetaSurvey.count.should == 0
    end
    
  end
end

def commit_results(results)
  parsed_results = JSON.parse(results)
  pollster = Pollster.find_by_uid(parsed_results["survey"]["pollster_uid"]) 
  
  if pollster.nil? 
    pollster = Factory(:pollster)
    pollster.update_attribute(:uid, parsed_results["survey"]["pollster_uid"])
  end
  device = Device.find_by_identifier(parsed_results["survey"]["device_id"])
  if device.nil?
    Factory(:device, :identifier => parsed_results["survey"]["device_id"])
  end

  Survey.build_from_hash(parsed_results["survey"])
end
