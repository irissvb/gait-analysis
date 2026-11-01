%% Ranges of Motion of the Hip, Knee, and Ankle Joints in the Sagittal Plane % Clear workspace
clear all;
close all;
clc %% 1. Import the data from the Excel file
% !!! DO NOT FORGET !!! to specify your file path
all_data = importfile_LD1('data\raw\imu\Participant 4\Participant 4-002.xlsx','Joint Angles ZXY','A:BO');
disp('Participant 4 NORMAL');
disp(' '); %% 2. Select hip, knee, and ankle joint data (sagittal plane)
hip_angle_flex_ext_right = all_data(10:end,46);
knee_angle_flex_ext_right = all_data(10:end,49);
knee_angle_flex_ext_right = -knee_angle_flex_ext_right;
ankle_angle_flex_ext_right = all_data(10:end,52); hip_angle_flex_ext_left = all_data(10:end,58);
knee_angle_flex_ext_left = all_data(10:end,61);
ankle_angle_flex_ext_left = all_data(10:end,64); % Assign to right and left limbs
right_limb = [hip_angle_flex_ext_right knee_angle_flex_ext_right ankle_angle_flex_ext_right];
left_limb = [hip_angle_flex_ext_left knee_angle_flex_ext_left ankle_angle_flex_ext_left]; % Generate time array
f = 60; % frame rate in Hz (Xsens)
deltaT = 1/f;
time = 0:deltaT:(length(hip_angle_flex_ext_right)-1)*deltaT;
time = time'; %% 3. Calculate maximum and minimum angles
max_right = max(right_limb);
min_right = min(right_limb); max_left = max(left_limb);
min_left = min(left_limb); disp('Right limb angles [Hip, Knee, Ankle] (deg):');
disp(['Max: ', num2str(max_right)]);
disp(['Min: ', num2str(min_right)]);
disp(' '); disp('Left limb angles [Hip, Knee, Ankle] (deg):');
disp(['Max: ', num2str(max_left)]);
disp(['Min: ', num2str(min_left)]);
disp(' '); %% 4. Calculate stride time (RIGHT and LEFT)
% Detect peaks on knee flexion for right limb
%[knee_peaks_r, locs_r] = findpeaks(knee_angle_flex_ext_right, 'MinPeakDistance', f*0.5, 'MinPeakProminence', 10);
[knee_peaks_r, locs_r] = findpeaks(knee_angle_flex_ext_right, ... 'MinPeakDistance', f*0.4, ... % slightly smaller min distance 'MinPeakProminence', 5); % more sensitive stride_times_right = diff(locs_r) / f;
stride_time_right = mean(stride_times_right); % Detect peaks on knee flexion for left limb
%[knee_peaks_l, locs_l] = findpeaks(knee_angle_flex_ext_left, 'MinPeakDistance', f*0.5, 'MinPeakProminence', 10);
[knee_peaks_l, locs_l] = findpeaks(knee_angle_flex_ext_left, ... 'MinPeakDistance', f*0.4, ... % slightly smaller min distance 'MinPeakProminence', 5); % more sensitive stride_times_left = diff(locs_l) / f;
stride_time_left = mean(stride_times_left); disp(['Right limb stride time (s): ', num2str(stride_time_right)]);
disp(['Left limb stride time (s): ', num2str(stride_time_left)]); % Cadence (same for both limbs, based on step time)
%step_time = (stride_time_right + stride_time_left)/2 / 2; % average step time
%cadence = 60 / step_time; % Check if peak detection failed
if length(stride_times_right) < 1 || length(stride_times_left) < 1 warning('Not enough peaks detected. Cadence cannot be computed.'); cadence = NaN;
else % step time = average stride time / 2 step_time = (stride_time_right + stride_time_left)/2 / 2; cadence = 60 / step_time;
end disp(['Cadence (steps/min): ', num2str(cadence)]); %% 5. Stride length and velocity
% Segment lengths
L_thigh = 0.4;
L_shank = 0.4; % Hip ROM
hip_rom_right = max(hip_angle_flex_ext_right) - min(hip_angle_flex_ext_right);
hip_rom_left = max(hip_angle_flex_ext_left) - min(hip_angle_flex_ext_left); % Step length estimation
step_length_right = (L_thigh + L_shank) * deg2rad(hip_rom_right);
step_length_left = (L_thigh + L_shank) * deg2rad(hip_rom_left); % Convert to stride length (2 steps)
stride_length_right = 2 * step_length_right;
stride_length_left = 2 * step_length_left; disp(['Right limb stride length (m): ', num2str(stride_length_right)]);
disp(['Left limb stride length (m): ', num2str(stride_length_left)]); % Mean velocity
velocity_right = stride_length_right / stride_time_right;
velocity_left = stride_length_left / stride_time_left;
velocity_mean = mean([velocity_right velocity_left]); disp(['Mean velocity (m/s): ', num2str(velocity_mean)]); %% 6. Plot right limb
figure
plot(time, right_limb, 'LineWidth',2);
xlim([1.5 6])
ylim([-85 55])
title('Right side with normal gait (Participant 4)')
xlabel('Time, s');
ylabel('Angle, ^{\circ}');
legend('Hip','Knee','Ankle'); %% 7. Plot left limb
figure
plot(time, left_limb, 'LineWidth',2);
xlim([1.5 6])
ylim([-30 65])
title('Left side with normal gait (Participant 4)')
xlabel('Time, s');
ylabel('Angle, ^{\circ}');
legend('Hip','Knee','Ankle'); %%
figure; plot(time, knee_angle_flex_ext_right); hold on;
plot(time(locs_r), knee_angle_flex_ext_right(locs_r), 'rv','MarkerFaceColor','r');
xlabel('Time (s)'); ylabel('Right knee angle (deg)');
title('Right knee with detected peaks'); grid on; figure; plot(time, knee_angle_flex_ext_left); hold on;
plot(time(locs_l), knee_angle_flex_ext_left(locs_l), 'rv','MarkerFaceColor','r');
xlabel('Time (s)'); ylabel('Left knee angle (deg)');
title('Left knee with detected peaks'); grid on;
