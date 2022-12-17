#pull branch
people_detection_ros2_branch="main"

# clone or pull people_detection_ros2
if [ -d ./people_detection_ros2 ]; then
    echo "[people_detection_ros2] is already cloned."

    while :
    do
        read -p "Update [people_detection_ros2？(Y/n)" pull_ans

        if [ "$pull_ans" = "Y" -o "$pull_ans" = "y" ]; then
            cd people_detection_ros2
            git pull origin $people_detection_ros2_branch
            cd ../

            echo "[people_detection_ros2] is updated!"
            echo ""
            break
        elif [ "$pull_ans" = "N" -o "$pull_ans" = "n" ]; then
            echo "Did not update [people_detection_ros2]."
            echo ""
            break
        else
            echo "Input Y or n key"
            echo ""
        fi
    done

else
    git clone -b $people_detection_ros2_branch git@github.com:Rits-Interaction-Laboratory/people_detection_ros2.git

    echo "[people_detection_ros2]'s clone is complete!"
    echo ""
fi