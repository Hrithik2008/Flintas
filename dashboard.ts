import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  ScrollView,
  StyleSheet,
  SafeAreaView,
  TouchableOpacity,
  Image,
  FlatList,
  Animated,
  Easing,
  ActivityIndicator,
} from 'react-native';

const DashboardScreen = ({ navigation }) => {
  const opacityAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(0.95)).current;
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Animated.parallel([
      Animated.timing(opacityAnim, {
        toValue: 1,
        duration: 800,
        useNativeDriver: true,
      }),
      Animated.timing(scaleAnim, {
        toValue: 1,
        duration: 800,
        easing: Easing.out(Easing.back(1.7)),
        useNativeDriver: true,
      }),
    ]).start(() => setLoading(false));
  }, []);

  const stats = [
    { icon: '📈', value: '12', label: 'Current Streak', color: '#6C63FF' },
    { icon: '⚡', value: '87%', label: 'Consistency', color: '#4FD1C5' },
    { icon: '👥', value: '24', label: 'Connections', color: '#F6AD55' },
    { icon: '⭐', value: '5', label: 'Achievements', color: '#F687B3' },
  ];

  const habits = [
    { icon: '🏋️', title: 'Workout', progress: 0.75, color: '#6C63FF' },
    { icon: '📖', title: 'Reading', progress: 0.9, color: '#4FD1C5' },
    { icon: '😴', title: 'Sleep', progress: 0.6, color: '#F6AD55' },
    { icon: '💧', title: 'Hydration', progress: 0.85, color: '#4299E1' },
  ];

  const activities = [
    { icon: '👍', title: 'Liked your ripple', subtitle: 'Sarah commented: "Great progress!"', time: '2h ago', color: '#F687B3' },
    { icon: '👥', title: 'New connection', subtitle: 'Michael joined your network', time: '5h ago', color: '#4FD1C5' },
    { icon: '🏆', title: 'Achievement unlocked', subtitle: '7-day streak in Workout', time: '1d ago', color: '#F6AD55' },
  ];

  const renderStatItem = ({ item }) => (
    <View style={[styles.statCard, { backgroundColor: `${item.color}20` }]}>
      <View style={[styles.statIcon, { backgroundColor: `${item.color}33` }]}>
        <Text>{item.icon}</Text>
      </View>
      <Text style={[styles.statValue, { color: item.color }]}>{item.value}</Text>
      <Text style={styles.statLabel}>{item.label}</Text>
    </View>
  );

  const renderHabitItem = ({ item }) => (
    <View style={styles.habitCard}>
      <Text style={{ fontSize: 24 }}>{item.icon}</Text>
      <Text style={styles.habitTitle}>{item.title}</Text>
      <View style={styles.progressBar}>
        <View style={[styles.progressFill, { width: `${item.progress * 100}%`, backgroundColor: item.color }]} />
      </View>
      <Text style={[styles.progressText, { color: item.color }]}>
        {Math.round(item.progress * 100)}%
      </Text>
    </View>
  );

  const renderActivityItem = ({ item }) => (
    <View style={styles.activityCard}>
      <View style={[styles.activityIcon, { backgroundColor: `${item.color}20` }]}>
        <Text>{item.icon}</Text>
      </View>
      <View style={styles.activityContent}>
        <Text style={styles.activityTitle}>{item.title}</Text>
        <Text style={styles.activitySubtitle}>{item.subtitle}</Text>
      </View>
      <Text style={styles.activityTime}>{item.time}</Text>
    </View>
  );

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#6C63FF" />
      </View>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <Animated.ScrollView
        style={[
          styles.scrollView,
          {
            opacity: opacityAnim,
            transform: [{ scale: scaleAnim }],
          },
        ]}
        contentContainerStyle={styles.contentContainer}
      >
        <View style={styles.header}>
          <Image
            source={{ uri: 'https://i.pravatar.cc/150?img=5' }}
            style={styles.avatar}
          />
          <View style={styles.headerText}>
            <Text style={styles.greeting}>Good Morning,</Text>
            <Text style={styles.username}>Alex Johnson</Text>
          </View>
          <TouchableOpacity>
            <Text>⋮</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.statsGrid}>
          <FlatList
            data={stats}
            renderItem={renderStatItem}
            keyExtractor={(item) => item.label}
            numColumns={2}
            scrollEnabled={false}
          />
        </View>

        <Text style={styles.sectionTitle}>Your Habits</Text>
        <FlatList
          data={habits}
          renderItem={renderHabitItem}
          keyExtractor={(item) => item.title}
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.habitsList}
        />

        <Text style={styles.sectionTitle}>Recent Activity</Text>
        <FlatList
          data={activities}
          renderItem={renderActivityItem}
          keyExtractor={(item) => item.title}
          scrollEnabled={false}
        />
      </Animated.ScrollView>

      <TouchableOpacity
        style={styles.fab}
        onPress={() => navigation.navigate('Ripple')}
      >
        <Text style={styles.fabIcon}>+</Text>
      </TouchableOpacity>

      <View style={styles.bottomNav}>
        <TouchableOpacity style={styles.navItem}>
          <Text style={styles.navIcon}>🏠</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem} onPress={() => navigation.navigate('Habits')}>
          <Text style={styles.navIcon}>📊</Text>
        </TouchableOpacity>
        <View style={styles.navSpacer} />
        <TouchableOpacity style={styles.navItem} onPress={() => navigation.navigate('Connections')}>
          <Text style={styles.navIcon}>👥</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem} onPress={() => navigation.navigate('Profile')}>
          <Text style={styles.navIcon}>👤</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  scrollView: {
    flex: 1,
  },
  contentContainer: {
    paddingHorizontal: 24,
    paddingVertical: 16,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 24,
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    marginRight: 16,
  },
  headerText: {
    flex: 1,
  },
  greeting: {
    fontSize: 16,
    color: '#666',
  },
  username: {
    fontSize: 20,
    fontWeight: '700',
  },
  statsGrid: {
    marginBottom: 32,
  },
  statCard: {
    flex: 1,
    margin: 8,
    padding: 16,
    borderRadius: 16,
  },
  statIcon: {
    width: 32,
    height: 32,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
  },
  statValue: {
    fontSize: 24,
    fontWeight: '800',
    marginBottom: 4,
  },
  statLabel: {
    fontSize: 12,
    color: '#666',
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 16,
  },
  habitsList: {
    paddingBottom: 16,
  },
  habitCard: {
    width: 150,
    marginRight: 12,
    padding: 16,
    borderRadius: 16,
    backgroundColor: '#fff',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  habitTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginTop: 16,
    marginBottom: 8,
  },
  progressBar: {
    height: 6,
    borderRadius: 3,
    backgroundColor: '#eee',
    overflow: 'hidden',
    marginBottom: 4,
  },
  progressFill: {
    height: '100%',
  },
  progressText: {
    fontSize: 12,
    fontWeight: '600',
    textAlign: 'right',
  },
  activityCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#eee',
    marginBottom: 12,
  },
  activityIcon: {
    width: 40,
    height: 40,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  activityContent: {
    flex: 1,
  },
  activityTitle: {
    fontSize: 14,
    fontWeight: '600',
  },
  activitySubtitle: {
    fontSize: 12,
    color: '#666',
    marginTop: 2,
  },
  activityTime: {
    fontSize: 12,
    color: '#999',
  },
  fab: {
    position: 'absolute',
    bottom: 70,
    right: 24,
    width: 56,
    height: 56,
    borderRadius: 16,
    backgroundColor: '#6C63FF',
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 4,
    elevation: 4,
  },
  fabIcon: {
    color: '#fff',
    fontSize: 28,
  },
  bottomNav: {
    flexDirection: 'row',
    height: 60,
    borderTopWidth: 1,
    borderTopColor: '#eee',
    alignItems: 'center',
    paddingHorizontal: 16,
  },
  navItem: {
    flex: 1,
    alignItems: 'center',
  },
  navIcon: {
    fontSize: 28,
  },
  navSpacer: {
    width: 48,
  },
});

export default DashboardScreen;