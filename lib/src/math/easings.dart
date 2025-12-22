import 'dart:math';

typedef EasingFunc = double Function(double p);

enum Easings {
  easeLinear(func: (linear)),
  easeQuadIn(func: quadIn),
  easeQuadOut(func: quadOut),
  easeQuadInOut(func: quadInOut),
  easeCubicIn(func: cubicIn),
  easeCubicOut(func: cubicOut),
  easeCubicInOut(func: cubicInOut),
  easeQuartIn(func: quartIn),
  easeQuartOut(func: quartOut),
  easeQuartInOut(func: quartInOut),
  easeQuintIn(func: quintIn),
  easeQuintOut(func: quintOut),
  easeQuintInOut(func: quintInOut),
  easeSineIn(func: sineIn),
  easeSineOut(func: sineOut),
  easeSineInOut(func: sineInOut),
  easeCircIn(func: circIn),
  easeCircOut(func: circOut),
  easeCircInOut(func: circInOut),
  easeExpoIn(func: expoIn),
  easeExpoOut(func: expoOut),
  easeExpoInOut(func: expoInOut),
  easeElasticIn(func: elasticIn),
  easeElasticOut(func: elasticOut),
  easeElasticInOut(func: elasticInOut),
  easeBackIn(func: backIn),
  easeBackOut(func: backOut),
  easeBackInOut(func: backInOut),
  easeBounceIn(func: bounceIn),
  easeBounceOut(func: bounceOut),
  easeBounceInOut(func: bounceInOut);

  final EasingFunc func;

  const Easings({required this.func});
  double call(double p) => func(p);
}


////////////////////////////////////////////////
//////////////// ease functions ////////////////
////////////////////////////////////////////////

//linear
double linear(double p) => p;

//quad
double quadIn(double p) => p * p;
double quadOut(double p) => p * (2 - p);
double quadInOut(double p) {
  if (p < 0.5) return 2 * p * p;
  return (-2 * p * p) + (4 * p) - 1;
}

//cubic
double cubicIn(double p) => p * p * p;
double cubicOut(double p) => --p * p * p + 1;
double cubicInOut(double p) {
  if (p < 0.5) return 4 * p * p * p;
  double f = 2 * p - 2;
  return 0.5 * f * f * f + 1;
}

//quart
double quartIn(double p) => p * p * p * p;
double quartOut(double p) => 1 - --p * p * p * p;
double quartInOut(double p) {
  if (p < 0.5) return 8 * p * p * p * p;
  double f = p - 1;
  return -8 * f * f * f * f + 1;
}

//quint
double quintIn(double p) => p * p * p * p * p;
double quintOut(double p) => --p * p * p * p * p + 1;
double quintInOut(double p) {
  if (p < 0.5) return 16 * p * p * p * p * p;
  double f = 2 * p - 2;
  return 0.5 * f * f * f * f * f + 1;
}

//sine
double sineIn(double p) => 1 - cos(p * pi / 2);
double sineOut(double p) => sin(p * pi / 2);
double sineInOut(double p) => 0.5 * (1 - cos(pi * p));

//circ
double circIn(double p) {
  p = clamp01(p);
  return 1 - sqrt(1 - p * p);
}
double circOut(double p){
  p = clamp01(p);
  return sqrt(1 - --p * p);
} 
double circInOut(double p) {
  p = clamp01(p);
  if (p < 0.5) return 0.5 * (1 - sqrt(1 - 4 * (p * p)));
  return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
}

//elastic
double elasticIn(double p) => sin(13 * pi / 2 * p) * pow(2, 10 * (p - 1));
double elasticOut(double p) => sin(-13 * pi / 2 * (p + 1)) * pow(2, -10 * p) + 1;
double elasticInOut(double p) {
  if (p < 0.5) return 0.5 * sin(13 * pi / 2 * (2 * p)) * pow(2, 10 * ((2 * p) - 1));
  return 0.5 * (sin(-13 * pi / 2 * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2);
}

//expo
double expoIn(double p) => p == 0 ? 0.0 : pow(1024, p - 1).toDouble();
double expoOut(double p) => p == 1 ? 1 : 1 - pow(2, -10 * p).toDouble();
double expoInOut(double p) {
  if (p == 0) return 0;
  if (p == 1) return 1;
  if ((p *= 2) < 1) return 0.5 * pow(1024, p - 1);
  return 0.5 * (-pow(2, -10 * (p - 1)) + 2);
}

//back
double backIn(double p) {
  const s = 1.70158;
  return p * p * ((s + 1) * p - s);
}

double backOut(double p) {
  const s = 1.70158;
  return --p * p * ((s + 1) * p + s) + 1;
}

double backInOut(double p) {
  const s = 1.70158 * 1.525;
  if ((p *= 2) < 1) return 0.5 * (p * p * ((s + 1) * p - s));
  return 0.5 * ((p -= 2) * p * ((s + 1) * p + s) + 2);
}

//bounce
double bounceIn(double p) => 1 - bounceOut(1 - p);
double bounceOut(double k) {
  if (k < (1 / 2.75)) return 7.5625 * k * k;
  if (k < (2 / 2.75)) return 7.5625 * (k -= (1.5 / 2.75)) * k + 0.75;
  if (k < (2.5 / 2.75)) return 7.5625 * (k -= (2.25 / 2.75)) * k + 0.9375;
  return 7.5625 * (k -= (2.625 / 2.75)) * k + 0.984375;
}

double bounceInOut(double k) {
  if (k < 0.5) return bounceIn(k * 2) * 0.5;
  return bounceOut(k * 2 - 1) * 0.5 + 0.5;
}


////////////////////////////////////////////////
//////////////// util functions ////////////////
////////////////////////////////////////////////

double clamp01(double value) {
  return value.clamp(0.0, 1.0).toDouble();
}

double lerp(double a, double b, double t) {
    return a + clamp01(t) * (b - a);
}

double lerpUnclamped(double a, double b, double t) {
    return a + t * (b - a);
}

extension TweenExtension on (double, double) {
 
  double lerp(double t) {
    return this.$1 + clamp01(t) * (this.$2 - this.$1);
  }

   double ulerp(double t) {
    return this.$1 + t * (this.$2 - this.$1);
  }
}
