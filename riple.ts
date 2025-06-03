import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  ScrollView,
  StyleSheet,
  TouchableOpacity,
  Image,
  FlatList,
  Animated,
  Modal,
  TextInput,
  RefreshControl,
} from 'react-native';
import { TabView, SceneMap, TabBar } from 'react-native-tab-view';

const RippleScreen = ({ navigation }) => {
  const [index, setIndex] = useState(0);
  const [routes] = useState([
    { key: 'following', title: 'Following' },
    { key: 'trending', title: 'Trending' },
    { key: 'nearby', title: 'Nearby' },
  ]);
  const [refreshing, setRefreshing] = useState(false);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [showCreateButton, setShowCreateButton] = useState(true);
  const [postText, setPostText] = useState('');
  const scrollY = useRef(new Animated.Value(0)).current;

  const FollowingRoute = () => (
    <FlatList
      data={[1, 2, 3, 4, 5]}
      renderItem={({ item }) => <PostCard />}
      keyExtractor={(item) => item.toString()}
      contentContainerStyle={styles.feedContainer}
      refreshControl={
        <RefreshControl
          refreshing={refreshing}
          onRefresh={() => {
            setRefreshing(true);
            setTimeout(() => setRefreshing(false), 1000);
          }}
        />
      }
      onScroll={Animated.event(
        [{ nativeEvent: { contentOffset: { y: scrollY } } }],
        { useNativeDriver: false }
      )}
      scrollEventThrottle={16}
    />
  );

  const TrendingRoute = () => (
    <View style={styles.tabContent}>
      <Text>Trending Content</Text>
    </View>
  );

  const NearbyRoute = () => (
    <View style={styles.tabContent}>
      <Text>Nearby Content</Text>
    </View>
  );

  const renderScene = SceneMap({
    following: FollowingRoute,
    trending: TrendingRoute,
    nearby: NearbyRoute,
  });

  useEffect(() => {
    const listener = scrollY.addListener(({ value }) => {
      setShowCreateButton(value <= 100);
    });

    return () => {
      scrollY.removeListener(listener);
    };
  }, []);

  const PostCard = () => {
    const [isLiked, setIsLiked] = useState(false);
    const [isBookmarked, setIsBookmarked] = useState(false);

    return (
      <View style={styles.postCard}>
        <View style={styles.postHeader}>
          <Image
            source={{ uri: 'https://i.pravatar.cc/150?img=3' }}
            style={styles.postAvatar}
          />
          <View style={styles.postUser}>
            <Text style={styles.postUsername}>Sarah Johnson</Text>
            <Text style={styles.postTime}>2h ago · Public</Text>
          </View>
          <TouchableOpacity>
            <Text>⋮</Text>
          </TouchableOpacity>
        </View>
        <Text style={styles.postText}>
          Just completed my 30-day meditation challenge! The difference in my focus and clarity is amazing.
          Who wants to join me for the next round?
        </Text>
        <Image
          source={{ uri: 'https://source.unsplash.com/random/600x400/?meditation' }}
          style={styles.postImage}
        />
        <View style={styles.postActions}>
          <TouchableOpacity
            style={styles.postAction}
            onPress={() => setIsLiked(!isLiked)}
          >
            <Text style={[styles.postActionIcon, isLiked && styles.liked]}>
              {isLiked ? '❤️' : '🤍'}
            </Text>
            <Text style={styles.postActionCount}>24</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.postAction}>
            <Text style={styles.postActionIcon}>💬</Text>
            <Text style={styles.postActionCount}>5</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.postAction, styles.postActionRight]}
            onPress={() => setIsBookmarked(!isBookmarked)}
          >
            <Text style={styles.postActionIcon}>
              {isBookmarked ? '🔖' : '📑'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <TabView
        navigationState={{ index, routes }}
        renderScene={renderScene}
        onIndexChange={setIndex}
        renderTabBar={(props) => (
          <TabBar
            {...props}
            style={styles.tabBar}
            indicatorStyle={styles.tabIndicator}
            labelStyle={styles.tabLabel}
          />
        )}
      />

      <Animated.View
        style={[
          styles.createButton,
          {
            opacity: showCreateButton ? 1 : 0,
            transform: [
              {
                scale: scrollY.interpolate({
                  inputRange: [0, 100],
                  outputRange: [1, 0],
                  extrapolate: 'clamp',
                }),
              },
            ],
          },
        ]}
      >
        <TouchableOpacity onPress={() => setShowCreateModal(true)}>
          <View style={styles.createButtonInner}>
            <Text style={styles.createButtonIcon}>+</Text>
          </View>
        </TouchableOpacity>
      </Animated.View>

      <Modal
        visible={showCreateModal}
        animationType="slide"
        transparent
        onRequestClose={() => setShowCreateModal(false)}
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            <View style={styles.modalHandle} />
            <TextInput
              style={styles.postInput}
              placeholder="What's happening?"
              multiline
              autoFocus
              value={postText}
              onChangeText={setPostText}
            />
            <View style={styles.modalActions}>
              <TouchableOpacity style={styles.modalAction}>
                <Text style={styles.modalActionIcon}>🖼️</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.modalAction}>
                <Text style={styles.modalActionIcon}>😊</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={styles.postButton}
                disabled={!postText}
              >
                <Text style={styles.postButtonText}>Post</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  tabBar: {
    backgroundColor: '#fff',
    elevation: 0,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  tabIndicator: {
    backgroundColor: '#6C63FF',
    height: 3,
  },
  tabLabel: {
    color: '#000',
    fontWeight: '600',
    textTransform: 'none',
  },
  tabContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  feedContainer: {
    paddingVertical: 8,
  },
  postCard: {
    marginHorizontal: 16,
    marginVertical: 8,
    padding: 16,
    borderRadius: 16,
   