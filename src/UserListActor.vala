// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/***
    BEGIN LICENSE

    Copyright (C) 2011-2013 elementary Developers

    This program is free software: you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License version 3, as published
    by the Free Software Foundation.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranties of
    MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
    PURPOSE.  See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program.  If not, see <http://www.gnu.org/licenses/>

    END LICENSE
***/


public class UserListActor : Clutter.Actor {
    UserList userlist;

    Gee.HashMap<LoginOption, LoginBox> boxes = new Gee.HashMap<LoginOption, LoginBox> ();

    public UserListActor (UserList userlist) {
        this.userlist = userlist;

        for (int i = 0; i < userlist.size; i++) {
           var box = new LoginBox (userlist.get_user (i));
           boxes.set (userlist.get_user (i), box);
           add_child (box);
        }

        userlist.current_user_changed.connect ((user) => {
            animate_list (user, 400);
        });
    }

    private float[] get_y_for_users (LoginOption current_user) {
        float[] result = new float[userlist.size];

        float run_y = 0;

        float current_user_y = 0;

        for (int i = 0; i < userlist.size; i++) {
            LoginOption user = userlist.get_user (i);

            result[i] = run_y;

            run_y += 50;
            if (user != current_user && userlist.get_next (user) == current_user) {
                run_y += 100;
            }
            if (user == current_user) {
                current_user_y = run_y;
                run_y += 100;
            }

        }

        for (int i = 0; i < userlist.size; i++) {
            result[i] = result[i] - current_user_y;
        }

        return result;
    }

    public LoginBox get_current_loginbox () {
        var user = userlist.current_user;
        return boxes.get (user);
    }

    private void animate_list (LoginOption current_user, int duration) {
        float[] y_vars = get_y_for_users (current_user);

        for (int i = 0; i < userlist.size; i++) {
            LoginOption user = userlist.get_user (i);
            LoginBox box = boxes.get (user);
            box.animate (Clutter.AnimationMode.EASE_IN_OUT_QUAD, 300, y: y_vars[i]);

            box.selected = (user == current_user); 
        }

    }
}