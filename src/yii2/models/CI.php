<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "CI".
 *
 * @property integer $UserID
 * @property integer $ProjectID
 * @property integer $Owner
 * @property integer $confirmDelete
 *
 * @property PROJECTS $project
 * @property USERS $user
 */
class CI extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'CI';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['UserID', 'ProjectID'], 'required'],
            [['UserID', 'ProjectID', 'Owner', 'confirmDelete'], 'integer'],
            [['ProjectID'], 'exist', 'skipOnError' => true, 'targetClass' => PROJECTS::className(), 'targetAttribute' => ['ProjectID' => 'ProjectID']],
            [['UserID'], 'exist', 'skipOnError' => true, 'targetClass' => USERS::className(), 'targetAttribute' => ['UserID' => 'UserID']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'UserID' => 'User ID',
            'ProjectID' => 'Project ID',
            'Owner' => 'Owner',
            'confirmDelete' => 'Confirm Delete',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProject()
    {
        return $this->hasOne(PROJECTS::className(), ['ProjectID' => 'ProjectID']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getUser()
    {
        return $this->hasOne(USERS::className(), ['UserID' => 'UserID']);
    }
}
