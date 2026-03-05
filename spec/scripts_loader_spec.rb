# frozen_string_literal: true

RSpec.describe DevOops::ScriptsLoader do
  describe ".build_action" do
    let(:config) do
      DevOops::ScriptsLoader::ScriptConfig.new(
        "test_script",
        "Missing description",
        "test_script",
        "/tmp/test_script.sh",
        args,
        "/tmp",
      )
    end
    let(:action_class) { described_class.build_action(config) }

    context "with boolean args" do
      let(:args) do
        [
          {
            "name" => "verbose",
            "desc" => "Enable verbose mode",
            "aliases" => ["v"],
            "required" => false,
            "boolean" => true,
          },
        ]
      end

      it "registers a boolean option" do
        option = action_class.class_options["verbose"]
        expect(option).not_to be_nil
        expect(option.type).to eq(:boolean)
      end

      it "has no default when none is specified" do
        option = action_class.class_options["verbose"]
        expect(option.default).to be_nil
      end

      context "with a default value" do
        let(:args) do
          [
            {
              "name" => "verbose",
              "desc" => "Enable verbose mode",
              "boolean" => true,
              "default" => false,
            },
          ]
        end

        it "uses the specified default" do
          option = action_class.class_options["verbose"]
          expect(option.default).to be false
        end
      end
    end

    context "with non-boolean args" do
      let(:args) do
        [
          {
            "name" => "output",
            "desc" => "Output file",
            "aliases" => ["o"],
            "required" => false,
          },
        ]
      end

      it "registers a string option" do
        option = action_class.class_options["output"]
        expect(option).not_to be_nil
        expect(option.type).to eq(:string)
      end
    end

    context "with no args" do
      let(:args) { nil }

      it "builds an action without options" do
        expect(action_class.class_options).to be_empty
      end
    end
  end
end
