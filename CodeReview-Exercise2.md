# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   


# Solution Assessment #

## Peer-reviewer Information

* *name:* Aryan Saneinejad 
* *email:* asaneinejad@ucdaivs.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera controller correctly centers on the Vessel as required, and the 5x5 unit cross appears accurately in the center of the screen when draw_camera_logic is enabled.

___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The autoscrolling feature is implemented smoothly, allowing the player to move within the defined frame border box on the z-x plane. 
When the player lags behind and touches the left edge, they are correctly pushed forward, as specified.

___
### Stage 3 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The position lock and lerp smoothing features are correctly implemented, with the camera following the player at follow_speed and catching up smoothly at catchup_speed when the player stops moving.
The 5x5 unit cross does not fully follow the Vessel, slightly affecting the alignment when draw_camera_logic is enabled.

___
### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The variant position-lock with lerp-smoothing is implemented correctly, with the camera leading the player in the direction of movement input and smoothly returning to the player’s position when the player stops. 
The leash_distance is effectively managed, and the camera stays centered on the player after the catchup_delay_duration has elapsed.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation is missing the required push zone functionality. 
Specifically, there is no visible pushbox zone that enables the Vessel to move within the speedup and push zones as described.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

#### Style Guide Exemplars ####
Methods are kept concise, with logical breaks, which helps maintain a clear structure. 
The switch statements are complete, covering all possible conditions without empty default cases.
___
#### Put style guide infractures ####
Based on the review I had, adding documentation comments for parameters and return values, particularly in complex methods like the camera controller, would also improve code clarity. 
It was a little confusing to follow the parameters and the methods in CameraController class.

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
In Stage 5, the absence of a clearly defined push zone restricts the camera from correctly responding within the designated speedup and pushbox areas, limiting its effectiveness. 
Consider implementing clear boundaries for these zones to enhance functionality.
Redundant conditional checks in Stage 5’s pushbox logic - Repetitive conditional checks in this section introduce unnecessary complexity, making the code harder to read and maintain. 
Simplifying the checks would improve code clarity, streamline logic, and make future adjustments to the pushbox behavior easier to manage.


#### Best Practices Exemplars ####
Thoughtful method organization and logical breaks - Methods across all stages are kept concise, with each method logically broken into distinct parts. 
This enhances readability, simplifies debugging, and ensures that each method performs a single responsibility, aligning with clean code principles.
The student made a significant number of commits throughout the project, which is a great practice.

