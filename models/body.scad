

body_width = 100;
body_length = 110;
body_height = 25;

small_screw_d_thread = 2;
small_screw_d_pass = 3.2;
small_screw_length = 13;
small_screw_head_length = 3;
small_screw_head_d = 6;

motor_d = 12;
motor_height = 10;
motor_length = 19;
motor_back_offset = 20;

cabel_channel_width = 6;

motor_holder_width = 32;
motor_holder_bulge = 16;

battery_box_width = 64;
battery_box_length = 59;
battery_box_depth = 2;
battery_box_back_offset = 10;
battery_box_cable_width = 12;
battery_box_cable_length = 5;
battery_box_cable_offset = 10; 

electronic_cutout_width = 38;
electronic_cutout_length = 59;
electronic_cutout_depth = 22;

button_cutout_length = 15;
button_cutout_width =  9;
button_x_offset = (electronic_cutout_width - button_cutout_width) / 2;
button_y_offset = -(electronic_cutout_length - button_cutout_length) / 2;

ball_wheel_width = 51;
ball_wheel_length = 25;
ball_wheel_depth = 9;
ball_wheel_front_offset = 10;
ball_wheel_screw_distance = 40;

tolerance = 0.2;

module mirror_copy(vec) {
        mirror(vec) {
            children();
        }
        children();
}

module small_screw_pass_cutout() {
    cylinder(d = small_screw_d_pass, h = small_screw_length, center = true);
    translate([0,0, (small_screw_length + small_screw_head_length) / 2])
        cylinder(d = small_screw_head_d, h = small_screw_head_length, center = true);
}

module small_screw_thread_cutout() {
    cylinder(d = small_screw_d_thread, h = small_screw_length, center = true);
}

module motor_holder() {
    difference() {
        union() {
            cube([motor_length, motor_holder_width, motor_height / 2], center = true);

            translate([0,0,motor_height / 4])
            rotate([0, 90, 0])
                cylinder(d = motor_holder_bulge, h = motor_length, center = true);
        }

        translate([0,0,motor_height / 4])
        rotate([0, 90, 0]) {           
            difference() {
                cylinder(d = motor_d, h = motor_length, center = true);
                    
                mirror_copy([1,0,0]) {
                    translate([(motor_height + 2) / 2, 0, 0])
                    cube([2, motor_d, motor_length], center = true);
                }
            }
        }

        translate([0,0, motor_height / 4 + motor_height / 2])
            cube([motor_length, motor_holder_width, motor_height], center = true);

        translate([0,0, - motor_holder_bulge / 2 + (motor_d - motor_height) / 2 ])
            cube([motor_length, motor_holder_width, motor_height / 2], center = true);

        mirror_copy([0, 1, 0])
        translate([0, motor_holder_width / 2 - 5, (small_screw_length) / 2 + small_screw_head_length - motor_height / 4 ])
        rotate([0, 180, 0])
            small_screw_pass_cutout();
    }
}

module body() {
    width = body_width;
    length = body_length;
    height = body_height;

    module motor_cutouts() {
        rotate([0, 90, 0]) {
            // cable shaft
            channel_length = body_width / 2 - motor_length;

            translate([0, 0, (- channel_length - motor_length) / 2 ])
                cube([cabel_channel_width, cabel_channel_width, channel_length], center = true);
            
            difference() {
                cylinder(d = motor_d, h = motor_length + 2 * tolerance, center = true);
                
                mirror_copy([1,0,0]) {
                    translate([(motor_height + 2) / 2, 0, 0])
                    cube([2, motor_d, motor_length], center = true);
                }
            }
        }
        
        mirror_copy([0,1,0])
        translate([0, motor_holder_width / 2 - 5, small_screw_length / 2]) {
            small_screw_thread_cutout();
        }

        translate([0, 0, -motor_height / 4])
            cube([motor_length + 2 * tolerance, motor_holder_width + 2 * tolerance, motor_height / 2 + tolerance], center = true);
    }
    
    module battery_box_cutout() {
        cube([battery_box_width, battery_box_length, battery_box_depth], center = true);

        translate([- battery_box_width / 2 + battery_box_cable_offset + battery_box_cable_width / 2, - battery_box_length / 2, 0])
            cube([battery_box_cable_width, battery_box_cable_length, electronic_cutout_depth], center = true);
    }
    
    module ball_wheel_cutout() {
        cube([ball_wheel_width, 
              ball_wheel_length,
              ball_wheel_depth], center = true);

        mirror_copy([1,0,0])
            translate([ball_wheel_screw_distance / 2,0,small_screw_length / 2])
            small_screw_thread_cutout();
    }
    
    module electronic_cutout() {
        cube([electronic_cutout_width,
              electronic_cutout_length,
              electronic_cutout_depth],
             center = true);

        translate([button_x_offset, button_y_offset, 0])
            cube([button_cutout_width, button_cutout_length, body_height], center = true);
    }

    difference() {
        union() {
            cube([width, length, height], center = true);
        }
            
        mirror_copy([1, 0, 0]) {
            translate([(width - motor_length) / 2, length / 2 - motor_back_offset,
            - (height - motor_height) / 2])
            motor_cutouts();
        }
        
        translate([0, (length - battery_box_length) / 2 - battery_box_back_offset, (height - battery_box_depth) / 2])
            battery_box_cutout();
        
        translate([0,
                   (length - electronic_cutout_length) / 2 - battery_box_back_offset,
                   (height - electronic_cutout_depth) / 2 - battery_box_depth])
            electronic_cutout();
        
        translate([0,
                  (length - ball_wheel_length) / -2 + ball_wheel_front_offset,
                  (height - ball_wheel_depth) / -2
            ])
            ball_wheel_cutout();
    }
}

body();

translate([(body_width - motor_length) / 2,
            body_length / 2 - motor_back_offset,
            - (body_height - motor_height) / 2 - motor_height / 4])
    motor_holder();
    
