/**
 * Hermit Retro Thumb Joystick controller case
 * (c)2019 Hermit Retro Products <https://hermitretro.com>
 */

include <eagle-pcb/common.scad>;
use <../../pcb/hermitretro-controller/3.0/output/gerber_openscad/hermitretro-controller.scad>;

case_to_board_offsetx = -12;
case_to_board_offsety = -10;

$fn = 128;

removetop = false;
removebottom = false;
cutaway = false;

useFurniture = false;
useRainbow = false;

useLipo = false;

module newcase() {
    scale( [ 0.96, 0.97, 1 ] )
        minkowski() {
            linear_extrude(height = 16, center = true, convexity = 10)
                import( "case_z_section_wide.dxf" );
    
            sphere(r=3);
        }
}    

module case() {
    grooveposz = 1.6 + 1.6 - 0.7;
    union() {
        difference() {
            translate( [ 0, 0, 2 ] ) {
                union() {
                    newcase();
                    translate( [ 0, 0, 2 ] )
                        topshelf();
                }
            }
            /** Join groove */
            /** Remove a 1mm section at the split point, then union the groove rounding sections in */
            translate( [ 100 - 20, 50 - 20, grooveposz ] )
                cube( [ 200, 100, 2 ], center=true );
        }
        /** Upper join groove */
        translate( [ 0, 0, grooveposz - 1 ] )
            uppergroove();
        /** Lower join groove */
        translate( [ 0, 0, grooveposz - 1 ] )
            lowergroove();
    }
}

module topshelf() {
        difference() {
            translate( [ 0, 0, 2 ] )
                newcase();
//            translate( [ 80, -687, 400 ] )
//                rotate( [ -45, 0, 0 ] )
//                    cylinder( h=300, r=800, $fn=256 );
            translate( [ -15, -82, 20 ] )
                rotate( [ -45, 0, 0 ] )
                    cube( [ 200, 100, 100 ] );
        }
}

/** Groove running round case split point */
module groove() {
    scale( [ 0.96, 0.97, 0.3 ] )
        minkowski() {
            linear_extrude(height = 0.5, center = true, convexity = 10)
                import( "case_z_section_wide.dxf" );

            sphere(r=3);
        }
}

module uppergroove() {
    difference() {
        translate( [ 0, 0, 1.9 ] )
            groove();
        translate( [ -3, -3, -1 ] )
            cube( [ 200, 100, 2 ] );
    }
}    

module lowergroove() {
    difference() {
        groove();
        translate( [ -3, -3, -2 ] )
            cube( [ 200, 100, 2 ] );
    }
}    

/** Logos */
module unclear_logo2() {
    translate( [ -65.8, 3.5, 20 ] )
        scale( [ 0.1, 0.1, 1 ] )
            linear_extrude(height = 2, center = true, convexity = 10)
            import( "hermit_sinclair_logo.dxf" );
}

module buttonhole() {
    translate( [ 0, 0, 2 ] )
        cylinder( d=12.75, h=5, center=true );
//    scale( [ 1.1, 1.1, 1.1 ] )
//        button();
}

module buttonriser() {
    /** Match buttonhole. Gives a rounded bevel */
    rotate_extrude()
        translate( [ (12.75 / 2), 0, 0 ] )
            scale( [ 1.3, 1, 1 ] )
                circle( d=2 );
}

module button() {
    translate( [ 0, 0, 1 ] )
    scale( [ 1.74, 1.74, 1.74 ] )
        union() {
            rotate_extrude(convexity = 10)
                translate([2, 0, 0])
                    circle(r = 0.5);
            translate( [ 0, 0, 0.3 ] )
                scale( [ 1, 1, 0.4 ] )
                    sphere( r=2 );
            translate( [ 0, 0, -1 ] )
                cylinder( h=1, r=2.5 );
        }
}

module joystickbulb() {
    scale( [ 0.8, 0.8, 0.32 ] )
        sphere( d=44, center=true );    
}

module joystickhole() {
    union() {
        scale( [ 0.75, 0.75, 0.32 ] )
            sphere( d=42, center=true );
        cylinder( d=24, h=25, center=true );
    }
}

module lipo() {
    cube( [ 26.2, 20, 4 ], center=true );
}

module lipocompartment() {
    difference() {
        cube( [ 29, 23, 7 ], center=true );
        translate( [ 0, 0, 1.01 ] )
            cube( [ 27.2, 21, 5 ], center=true );

        /** Knock out corner where wires emerge */
        translate( [ 10, 8, 0 ] )
            cube( [ 10, 10, 10 ], center=true );
        
    }
}

module pcbsupport(height=10) {
    /** Insets are 4.8mm high, 4mm diameter required for flush melt-fit */
    difference() {
        cylinder( h=height + 0.01, d=8, center=true, $fn=64 );
        translate( [ 0, 0, -0.01] )
            cylinder( h=height, d=4, center=true );
    }
}

module lowerpcbhole(height=10) {
    union() {
        cylinder( d=4, h=height, center=true );
        translate( [ 0, 0, -height / 2 ] )
            cylinder( d1=8, d2=4, h=4, center=true );
    }
}

/** Battery LED indicator rainbow */
module ledstripe_cutout(width=4, height=30, depth=10, yoffset=0) {
    difference() {
        rotate( [ 0, 0, -30 ] )
            cube( [ width, height, depth ], center=true );
        /** Plane off bottom edge */
        translate( [ 5, height - 5 - yoffset, 0 ] )
            cube( [ 10, 10, depth + 1 ], center=true );
        /** Plane off top edge */
        translate( [ -5, -height + 5 + yoffset, 0 ] )
            cube( [ 10, 10, depth + 1 ], center=true );
    }
}

/** Battery LED indicator rainbow cover piece */
module ledstripe_insert(depth=12) {
    
    difference() {
        group() {
            /** Backing plate */
//            translate( [ -1.5, 0, 0 ] )
//                cube( [ 33, 10, 1 ], center=true );
            
            /** Four insets */
            translate( [ -9, 0, 0.99 ] ) {
                color(red) render() {
                    translate( [ 0, 0, -0.5 ] )
                        scale( [ 1, 1.1, 1 ] )
                            ledstripe_cutout(width=4.1, height=15, yoffset=0.6, depth=depth);
                }
                color(yellow) render() {
                    translate( [ 6.6, 0, -0.5 ] )
                        scale( [ 1, 1.1, 1 ] )
                            ledstripe_cutout(width=4.1, height=15, yoffset=0.6, depth=depth);
                }
                color(green) render() {
                    translate( [ 13.2, 0, -0.5 ] )
                        scale( [ 1, 1.1, 1 ] )
                            ledstripe_cutout(width=4.1, height=15, yoffset=0.6, depth=depth);
                }
                color(cyan) render() {
                    translate( [ 19.8, 0, -0.5 ] )
                        scale( [ 1, 1.1, 1 ] )
                            ledstripe_cutout(width=4.1, height=15, yoffset=0.6, depth=depth);
                }
            }
        }
        
        /** Remove the insides of the stripes */
//        translate( [ -8.8, 0, 0.99 ] ) {
//            for ( x = [ 0 : 6 : 18 ] ) {
//                translate( [ x - 0.25, 0, 1 ] )
//                    ledstripe_cutout(width=3.2, height=7, yoffset=1.2);
//            }
//        }
    }
}

module completecase() {

    button1x = 136.43 - case_to_board_offsetx - 52 - 13 + 25.18 - 6.8 - 9;
    button1y = 24.13 - 7.3 - 2 + 5;
    
    button2x = 146.59 - case_to_board_offsetx - 52 - 9.2 + 18 - 6.8 + 3 - 9;
    button2y = 33.02 - 2 - 1 + 5;
    
    joystickx = 30.78  - case_to_board_offsetx - 10 + 11.96 - 3 - 9 + 0.5 - 1 - 0.75;
    joysticky = 38.02 - 12.1 + 1 - 0.75;
    
    difference() {  /** Remove rainbow stripes */
        union() {
            difference() {
                translate( [ 0, 0, -1 ] ) {
                    union() {    
        //                color(dark) render() {
                        if ( 1 ) {
                            difference() {
                                union() {
                                    scale( [ 0.71, 1, 1 ] )
                                        translate( [ 0, 0, 0 ] )
                                            case();
                                    /** Button rings */
                                    translate( [ button1x, button1y, 12.6 ] ) {
                                        buttonriser();
                                    }
                                    translate( [ button2x, button2y, 12.6 ] ) {
                                        buttonriser();
                                    }
                                    
                                    translate( [ joystickx, joysticky, 13 ] ) {
                                        joystickbulb();
                                    }
                                }
                                    
    
                                /** USB socket */
                                if ( useLipo ) {
                                    translate( [ 56.7 - case_to_board_offsetx, 63, -0.5 ] )
                                        cube( [ 14, 10, 8 ] );
                                }
    
                                /** Recharge LED */
                                if ( useLipo ) {
                                    translate( [ 71.6 - case_to_board_offsetx, 63, 2 ] )
                                        cube( [ 4, 10, 2 ] );
                                }
                                
                                /** Power switch */
                                if ( useLipo ) {
                                    translate( [ 26.2 - case_to_board_offsetx, 63, 1.25 ] )
                                        cube( [ 12.5, 10, 6.5 ] );                        
                                }    
    
                                /** Joystick cable */
                                translate( [ 44.5 - case_to_board_offsetx, 63, 2 ] )
                                    cube( [ 6, 10, 10 ] );
    
                                /** Right buttons */
                                translate( [ button1x, button1y, 9.2 ] )
                                    buttonhole();
                                translate( [ button2x, button2y, 9.2 ] )
                                    buttonhole();
                    
                                /** Joystick */
                                translate( [ joystickx, joysticky, 12.5 ] )
                                    joystickhole();
                        }
                    }
                    
                        /** Logos */
                        translate( [ 93, 65, 36.5 ] ) {
                            rotate( [ 180, 0, 0 ] ) {
                                scale( [ 1.1, 1.1, 1 ] ) {
                                    unclear_logo2();
                                }
                            }
                        }
                        color(white) render() {
                            translate( [ 8.65, 56, 16.6 ] )
                                linear_extrude(height=1)
                                    text(text="ZX Controller", size=2);
                        }
                    }
                }
                
                /** Hollow out inside */
                translate( [ 1.3, 1.2, 1 ] )
                    scale( [ 0.69, 0.96, 0.85 ] )
                        newcase();                
            } /** End of shell */
            
            /** Add lipo compartment */
            if ( useLipo ) {
                translate( [ 59, 36, -5 ] ) {
                    rotate( [ 0, 0, 90 ] ) {
                        lipocompartment();
                    }
                }
            }
            
            /** Add rainbow stripe block in such that when we remove the stripes, the separators go down to the LED to avoid light bleed */
            translate( [ 99.5, 62.5, 9 ] ) {
                difference( ){
                    cube( [ 40, 14, 10 ], center=true );
                    translate( [ -21.5, 0, 0 ] )
                        rotate( [ 0, 0, -30 ] )
                            cube( [ 10, 30, 11 ], center=true );
                    translate( [ 18, 0, 0 ] )
                        rotate( [ 0, 0, -30 ] )
                            cube( [ 10, 30, 11 ], center=true );
                }
            }
        }
        
        /** Remove rainbow stripes for battery LEDs */
        stripewidth = 4.5;
        stripestep = stripewidth + 2;
        translate( [ 88, 61.5, 11.1 ] ) {
            translate( [ 0, 0, 0 ] )
                ledstripe_cutout(width=stripewidth, height=15, depth=15);
            translate( [ stripestep, 0, 0 ] )
                ledstripe_cutout(width=stripewidth, height=15, depth=15);
            translate( [ stripestep * 2, 0, 0 ] )
                ledstripe_cutout(width=stripewidth, height=15, depth=15);
            translate( [ stripestep * 3, 0, 0 ] )
                ledstripe_cutout(width=stripewidth, height=15, depth=15);
        }

    }
}

module wholething() {
    if ( 1 ) {
        translate( [ case_to_board_offsetx, 0, 0 ] ) {
            difference() {
                union() {
                    difference() {
                        completecase();
                        if ( removebottom ) {
                            /** Remove bottom half */
                            translate( [ -10, -10, -18 - 0.5 ] )
                                cube( [ 200, 100, 20 ] );
                        }
                            
                        if ( removetop ) {
                            /** Remove top half */
                            translate( [ -10, -10, -0.1 + 2 - 0.5 ] )
                                cube( [ 200, 100, 20 ] );
                        }
                    }
                    
                    if ( !removebottom ) {
                        /** PCB supports -- lower shell */
                        translate( [ -case_to_board_offsetx - 2, -case_to_board_offsety - 6, -4.3 ] ) {
                            translate( [ 3.81, 3.81, 0 ] )
                                rotate( [ 180, 0, 0 ] )
                                    pcbsupport(height=8.2);
                            translate( [ 3.81, 57.15, 0 ] )
                                rotate( [ 180, 0, 0 ] )
                                    pcbsupport(height=8.2);
                            translate( [ 99.06, 43.815, 0 ] )
                                rotate( [ 180, 0, 0 ] )
                                    pcbsupport(height=8.2);
                            translate( [ 99.06, 3.81 ] )
                                rotate( [ 180, 0, 0 ] )
                                    pcbsupport(height=8.2);
                        }
                    }
                    
                    if ( !removetop ) {
                        /** PCB supports -- upper shell */
                        translate( [ -case_to_board_offsetx - 2, -case_to_board_offsety - 6, 6.21 ] ) {
                            translate( [ 3.81, 3.81, 0 ] )
                                pcbsupport(height=8.2);
                            translate( [ 3.81, 57.15, 0 ] )
                                pcbsupport(height=8.2);
                            translate( [ 99.06, 43.815, 0 ] )
                                pcbsupport(height=8.2);
                            translate( [ 99.06, 3.81, 0 ] )
                                pcbsupport(height=8.2);                            
                            /** Extra support to stop the top flexing near the buttons */
                            translate( [ 77, 27.5, 0 ] )
                                pcbsupport(height=8.2);                            
                        }
                    }
                }
            
                /** Remove PCB holes */
                if ( !removebottom ) {
                    translate( [ -case_to_board_offsetx - 2, -case_to_board_offsety - 6, -3 ] ) {
                        translate( [ 3.81, 3.81, 0 ] )
                            lowerpcbhole(height=12);
                        translate( [ 3.81, 57.15, 0 ] )
                            lowerpcbhole(height=12);
                        translate( [ 99.06, 43.815, 0 ] )
                            lowerpcbhole(height=12);
                        translate( [ 99.06, 3.81 ] )
                            lowerpcbhole(height=12);
                    }
                }
            }
        }
    }
}
     
if ( 1 ) {
    if ( cutaway ) {
//        color(lighterdark) render() {
            difference() {
                wholething();
                translate( [ -140, -25, -20 ] )
                    cube( [ 200, 100, 50 ] );
                translate( [ 100, -25, -20 ] )
                    cube( [ 100, 100, 50 ] );
            }
//        }
    } else {
//        color(lighterdark) render() {
            wholething();
//        }
    }
}

if ( useFurniture ) {
    translate( [ -2, 4, 1.6 ] )
        hermitretro_controller();

    translate( [ 47, 36, -2.5 ] ) {
        rotate( [ 0, 0, 90 ] ) {
            color(light) render() {
                lipo();
            }
        }
    }    
}

if ( useRainbow ) {
    translate( [ 85, 61.5, 9.5 ] ) {
        if ( useLipo ) {
            ledstripe_insert(depth=12);
        } else {
            ledstripe_insert(depth=6);
        }
    }
}