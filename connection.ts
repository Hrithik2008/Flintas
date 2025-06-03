import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
  FlatList,
  SafeAreaView,
} from 'react-native';

type Connection = {
  id: string;
  name: string;
  bio: string;
  avatarUrl: string;
};

const demoConnections: Connection[] = [
  {
    id: '1',
    name: 'Sarah Johnson',
    bio: 'Product Designer | UI/UX Enthusiast',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
  },
  {
    id: '2',
    name: 'Michael Chen',
    bio: 'Software Engineer | Open Source Contributor',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
  },
  {
    id: '3',
    name: 'Emma Wilson',
    bio: 'Digital Marketer | Content Creator',
    avatarUrl: 'https://i.pravatar.cc/150?img=10',
  },
  // Add more demo connections as needed
];

const ConnectionScreen = () => {
  const [selectedTab, setSelectedTab] = useState(0);
  const [searchText, setSearchText] = useState('');

  const renderTabContent = () => {
    switch (selectedTab) {
      case 0:
        return <AllConnections />;
      case 1:
        return <FollowingConnections />;
      case 2:
        return <FollowersConnections />;
      default:
        return <View />;
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Connections</Text>
        <TouchableOpacity onPress={() => console.log('Invite pressed')}>
          <Text style={styles.inviteButton}>Invite</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.searchContainer}>
        <TextInput
          style={styles.searchInput}
          placeholder="Search connections..."
          value={searchText}
          onChangeText={setSearchText}
        />
      </View>

      <View style={styles.tabBar}>
        <TouchableOpacity
          style={[
            styles.tabItem,
            selectedTab === 0 && styles.selectedTabItem,
          ]}
          onPress={() => setSelectedTab(0)}
        >
          <Text
            style={[
              styles.tabText,
              selectedTab === 0 && styles.selectedTabText,
            ]}
          >
            All
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[
            styles.tabItem,
            selectedTab === 1 && styles.selectedTabItem,
          ]}
          onPress={() => setSelectedTab(1)}
        >
          <Text
            style={[
              styles.tabText,
              selectedTab === 1 && styles.selectedTabText,
            ]}
          >
            Following
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[
            styles.tabItem,
            selectedTab === 2 && styles.selectedTabItem,
          ]}
          onPress={() => setSelectedTab(2)}
        >
          <Text
            style={[
              styles.tabText,
              selectedTab === 2 && styles.selectedTabText,
            ]}
          >
            Followers
          </Text>
        </TouchableOpacity>
      </View>

      <View style={styles.contentContainer}>{renderTabContent()}</View>
    </SafeAreaView>
  );
};

const AllConnections = () => {
  return (
    <FlatList
      data={demoConnections}
      renderItem={({ item, index }) => (
        <ConnectionListItem connection={item} isFollowing={index % 3 !== 0} />
      )}
      keyExtractor={(item) => item.id}
      contentContainerStyle={styles.listContainer}
    />
  );
};

const FollowingConnections = () => {
  const followingConnections = demoConnections.filter((_, index) => index % 3 !== 0);
  return (
    <FlatList
      data={followingConnections}
      renderItem={({ item }) => (
        <ConnectionListItem connection={item} isFollowing={true} />
      )}
      keyExtractor={(item) => item.id}
      contentContainerStyle={styles.listContainer}
    />
  );
};

const FollowersConnections = () => {
  const followerConnections = demoConnections.filter((_, index) => index % 3 === 0);
  return (
    <FlatList
      data={followerConnections}
      renderItem={({ item }) => (
        <ConnectionListItem connection={item} isFollowing={false} />
      )}
      keyExtractor={(item) => item.id}
      contentContainerStyle={styles.listContainer}
    />
  );
};

const ConnectionListItem = ({
  connection,
  isFollowing: initialFollowing,
}: {
  connection: Connection;
  isFollowing: boolean;
}) => {
  const [isFollowing, setIsFollowing] = useState(initialFollowing);

  return (
    <View style={styles.listItem}>
      <Image
        source={{ uri: connection.avatarUrl }}
        style={styles.avatar}
      />
      <View style={styles.userInfo}>
        <Text style={styles.userName}>{connection.name}</Text>
        <Text style={styles.userBio}>{connection.bio}</Text>
      </View>
      <TouchableOpacity
        style={[
          styles.followButton,
          isFollowing ? styles.followingButton : styles.followButtonActive,
        ]}
        onPress={() => setIsFollowing(!isFollowing)}
      >
        <Text
          style={[
            styles.followButtonText,
            isFollowing
              ? styles.followingButtonText
              : styles.followButtonTextActive,
          ]}
        >
          {isFollowing ? 'Following' : 'Follow'}
        </Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  inviteButton: {
    color: '#6C63FF',
    fontWeight: '600',
  },
  searchContainer: {
    paddingHorizontal: 24,
    paddingVertical: 16,
  },
  searchInput: {
    backgroundColor: '#f5f5f5',
    padding: 12,
    borderRadius: 12,
    paddingLeft: 40,
  },
  tabBar: {
    flexDirection: 'row',
    marginHorizontal: 24,
    backgroundColor: 'rgba(108, 99, 255, 0.1)',
    borderRadius: 12,
  },
  tabItem: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: 12,
  },
  selectedTabItem: {
    backgroundColor: 'rgba(108, 99, 255, 0.2)',
  },
  tabText: {
    textAlign: 'center',
    color: 'rgba(0, 0, 0, 0.6)',
  },
  selectedTabText: {
    fontWeight: '600',
    color: '#6C63FF',
  },
  contentContainer: {
    flex: 1,
  },
  listContainer: {
    paddingVertical: 16,
  },
  listItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    marginRight: 16,
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontWeight: '600',
    fontSize: 16,
    marginBottom: 4,
  },
  userBio: {
    color: 'rgba(0, 0, 0, 0.6)',
    fontSize: 14,
  },
  followButton: {
    width: 100,
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  followButtonActive: {
    backgroundColor: '#6C63FF',
  },
  followingButton: {
    backgroundColor: '#fff',
    borderWidth: 1,
    borderColor: '#ddd',
  },
  followButtonText: {
    fontWeight: '600',
    fontSize: 14,
  },
  followButtonTextActive: {
    color: '#fff',
  },
  followingButtonText: {
    color: '#000',
  },
});

export default ConnectionScreen;