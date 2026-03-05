if [[ $test_me == "yes" ]]; then
    echo "Test me is set to yes"
else
    echo "Test me is not set to yes"
fi

if [[ -z $boolean_flag ]]; then
    echo "Boolean flag is not set"
else
    echo "Boolean flag is set to $boolean_flag"
fi

echo "This is an example script."
