<div class="w3-container w3-padding-0 extra-margin-bottom" id="entry-panel">
    <div class="w3-row">
        <div class="w3-third"><p></p></div>
        <div class="w3-third w3-card-4 my-card-top_bottom entry-panel">
            <h2 class="w3-teal">
                <p class="w3-padding">Login</p>
            </h2>
            <div class="w3-container login-panel">
                <form action="" method="post" id="login-form">
                    <div class="w3-padding control-block">
                        <input class="my-input w3-input w3-right-align" type="text" name="username" id="uname" value="" required />
                        <label for="uname" class="my-label">Username:</label>
                    </div>
                    <div class="w3-padding control-block">
                        <input class="my-input w3-input w3-right-align" type="password" name="password" id="upass"name value="" required />
                        <label for="uname" class="my-label">Password:</label>
                    </div>
                    <button type="submit" class="w3-btn-block w3-teal w3-hover-shadow">Go!</button>
                </form>
            </div>
            <h2 class="reg-switch w3-deep-orange" ft="open-reg" tg="#entry-panel">
                <p class="w3-padding">REG</p>
                <p class="w3-hover-shadow w3-padding-large w3-xlarge reg-panel-close">&times;</p>
            </h2>
            <div class="w3-container reg-panel">
                <form action="" method="post" id="reg-form">
                    <div class="w3-padding control-block">
                        <input class="my-input w3-input w3-right-align" type="text" name="username" id="reguname" value="" required />
                        <label for="uname" class="my-label">Username:</label>
                    </div>
                    <div class="w3-padding control-block">
                        <input class="my-input w3-input w3-right-align" type="password" name="password" id="regupass" value="" required />
                        <label for="uname" class="my-label">Password:</label>
                    </div>
                    <div class="w3-padding control-block">
                        <input class="my-input w3-input w3-right-align" type="password" name="repassword" id="regrepass" value="" required />
                        <label for="uname" class="my-label">Confirm password:</label>
                    </div>
                    <div class="control-block">
                        <button type="submit" class="w3-btn-block w3-deep-orange w3-hover-shadow">Reg!</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="w3-row w3-center">
        <p class="w3-teal w3-padding teal-note">
            Need an account to login? Click <span class="w3-padding-small w3-deep-orange">REG</span> to get one.
        </p>
        <p class="w3-deep-orange w3-padding orange-note">
            Owned an account? Click <span calss="w3-padding-small w3-card-4">&times;</span> and login now!
        </p>
    </div>
</div>


<div class="w3-container w3-padding-0 extra-margin-bottom" id="project-list-panel">
    <div class="w3-row">
        <div class="w3-quarter"><p></p></div>
        <div class="w3-half w3-card-4 margin-bottom-16 relative-frame">
            <h2 class="w3-center w3-teal">
                <p class="w3-padding">Project List</p>
            </h2>
            <div class="limit-height w3-padding-small padding-bottom-16">
            </div>
            <div class="add-dialog w3-card-2 w3-hover-shadow" id="add-project-dialog" name="add-dialog">
                <h3 class="w3-teal w3-padding pointer" ft="open-dialog" tg="#add-project-dialog">
                        <i class="add-icon"></i>
                        <p class="w3-margin-0">
                            <span>Create new project</span>
                        </p>
                        <span class="w3-padding w3-right w3-hover-shadow" ft="close-dialog">&times;</span>
                </h3>
                <div class="w3-container">
                    <form action="" method="post" id="add-project-form">
                        <div class="w3-padding control-block">
                            <input class="w3-input my-input w3-right-align" type="text" name="Pname" id="pname" value="" required />
                            <label for="Pname" class="my-label">Project name:</label>
                        </div>
                        <div class="control-block">
                            <button type="submit" class="w3-btn-block w3-teal">Create</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="w3-container w3-padding-0 margin-bottom-16 padding-bottom-16 relative-frame" id="task-list-panel">
    <div class="w3-row-padding">
        <div class="w3-third">
            <div class="w3-card-4 extra-height">
                <h2 class="w3-teal w3-center">
                    <p class="w3-padding">To Do</p>
                </h2>
                <div class="w3-container limit-height w3-margin-tiny w3-padding-small" id="todoTask">
<!--
                    <div class="w3-border relative-frame obj-task" tkind="1">
                        <a href="#" ft="open-more">AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</a>
                        <p class="w3-small w3-text-grey w3-margin-0">Creator: oz</p>
                        <div class="more-info">
                            <div class="info">
                                This is some text to describe for this task. So provide everything you want to note about this task
                            </div>
                        </div>
                        <div class="btn-control w3-center">
                            <div>
                                <a href="#" class="w3-green">
                                    <i class="fa fa-angle-double-right"></i>
                                </a>
                                <a href="#" class="w3-red">
                                    <i class="fa fa-times"></i>
                                </a>
                            </div>
                        </div>
                    </div>
-->
                </div>
            </div>
        </div>
        <div class="w3-third">
            <div class="w3-card-4 extra-height">
                <h2 class="w3-teal w3-center">
                    <p class="w3-padding">Doing</p>
                </h2>
                <div class="w3-container limit-height w3-margin-tiny w3-padding-small" id="doingTask">
                </div>
            </div>
        </div>
        <div class="w3-third">
            <div class="w3-card-4 extra-height">
                <h2 class="w3-teal w3-center">
                    <p class="w3-padding">Done</p>
                </h2>
                <div class="w3-container limit-height w3-margin-tiny w3-padding-small" id="doneTask">
                </div>
            </div>
        </div>
    </div>
    <div class="add-dialog w3-hover-shadow w3-card-2" id="add-task-dialog">
        <h3 class="w3-teal w3-padding pointer" ft="open-dialog" tg="#add-task-dialog">
                <i class="add-icon"></i>
                <p class="w3-margin-0">
                    <span>Create new task</span>
                </p>
                <span class="w3-padding w3-right w3-hover-shadow">&times;</span>
        </h3>
        <div class="w3-container">
            <form action="" method="post">
                <div class="w3-padding control-block">
                    <input class="w3-input my-input w3-right-align" type="text" name="Tname" id="tname" value="" required />
                    <label for="Pname" class="my-label">Task name:</label>
                </div>
                <div class="w3-padding control-block">
                    <textarea class="w3-input my-input w3-right-align" rows="2" name="Tname" id="tdesc"></textarea>
                    <label for="Pname" class="my-label">Task discription:</label>
                </div>
                <div class="control-block">
                    <button type="submit" class="w3-btn-block w3-teal">Create</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="confirm-dialog w3-white padding-0" name="confirm-dialog">
    <h3 class="w3-teal w3-margin-0 w3-padding">
        <i class="fa fa-question w3-xxlarge"></i>
        &#32;Do you really want to do it?
    </h3>
    <div class="w3-padding-large w3-center relative-frame">
        <a href="#Y" class="w3-btn w3-border w3-hover-green w3-white w3-margin-tiny" ft="dimiss" name="confirm-button">
            <i class="fa fa-check w3-text-green"></i>
            &#32;Yes
        </a>
        <a href="#N" class="w3-btn w3-border w3-hover-red w3-white w3-margin-tiny" ft="dimiss" name="confirm-button">
            <i class="fa fa-times w3-text-red"></i>
            &#32;No
        </a>
    </div>
</div>

<footer class="my-footer w3-teal">
    <div class="w3-container w3-center">
        <span class="w3-left w3-padding-tiny w3-hover-shadow pj-show">
            <input class="w3-hide" type="checkbox" name="" id="notice-switch" value="" />
            <label for="notice-switch" class="w3-margin-0 pointer">
                <span class="w3-small">Login by: </span>
                <span id="logBy">
                <?php echo $uname;?>
                </span>
            </label>
            <ul class="w3-padding-0 w3-margin-0 menu-item">
                <li>
                    <a href="#reqSent"><i class="fa fa-upload"></i></a>
                    <ul class="dropUp w3-border w3-card-8 w3-padding-small w3-text-black w3-white w3-small" id="reqSentList">
                        <button type="button" class="w3-btn w3-padding-small w3-red w3-card-4 my-dimiss" ft="dimiss">&times;</button>
                        <li class="w3-teal w3-padding-small w3-medium w3-center w3-margin-tiny">Request was sent list</li>
                    </ul>
                </li>
                <li>
                    <a href="#reqReceived"><i class="fa fa-download"></i></a>
                    <ul class="dropUp w3-border w3-card-8 w3-padding-small w3-text-black w3-white w3-small" id="reqReceivedList">
                        <button type="button" class="w3-btn w3-padding-small w3-red w3-card-4 my-dimiss" ft="dimiss">&times;</button>
                        <li class="w3-teal w3-padding-small w3-medium w3-center w3-margin-tiny">Request was received list</li>
                    </ul>
                </li>
                <li>
                    <a href="#reqConfirm"><i class="fa fa-recycle"></i></a>
                    <ul class="dropUp w3-border w3-card-8 w3-padding-small w3-text-black w3-white w3-small" id="reqConfirm">
                        <button type="button" class="w3-btn w3-padding-small w3-red w3-card-4 my-dimiss" ft="dimiss">&times;</button>
                        <li class="w3-teal w3-padding-small w3-medium w3-center w3-margin-tiny">Vote for delete</li>
                    </ul>
                </li>
                <li class="search">
                    <a href="#search"><i class="fa fa-search"></i></a>
                    <ul class="dropUp w3-border w3-card-8 w3-padding-small w3-text-black w3-white w3-small">
                        <button type="button" class="w3-btn w3-padding-small w3-red w3-card-4 my-dimiss" ft="dimiss">&times;</button>
                        <li class="w3-teal w3-padding-small w3-medium w3-center w3-margin-tiny">Search</li>
                        <li class="w3-padding-small w3-border w3-margin-tiny">
                            <form id="search-form">
                                <input type="text" name="" id="searchId" value="" placeholder="Project name"
                                        class="w3-margin-0 w3-padding-0" />
                                <button type="submit" class="w3-btn w3-teal">Search</button>
                            </form>
                        </li>
                    </ul>
                </li>
            </ul>
        </span>
        <span class="w3-right w3-padding-tiny w3-hover-shadow pj-show">
            <a href="#out" class="w3-hover-text-white">
                <span class="w3-small">Logout </span>
                <i class="fa fa-sign-out"></i>
            </a>
        </span>
        <span class="w3-left w3-padding-tiny w3-hover-shadow task-show">
            <a href="#return">&nbsp;<i class="fa fa-angle-double-left"></i>&nbsp;&nbsp;&nbsp;&nbsp;</a>
        </span>
        <span class="w3-right w3-padding-tiny w3-hover-shadow task-show">
            <span class="w3-tiny">Current Project</span>&nbsp;
            <span id="curPj"><?php echo $pname;?></span>
        </span>
    </div>
</footer>
