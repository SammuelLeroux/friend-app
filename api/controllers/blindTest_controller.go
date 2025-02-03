package controllers

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/configs"
	"github.com/EpitechMscProPromo2026/T-YEP-600-STG_12/models"
)

var clientId = configs.EnvClientID()
var clientSecret = configs.EnvClientSecret()
var playlistId = configs.EnvPlaylistID()
var accessToken string

func init() {
	var err error
	accessToken, err = GetAccessToken()
	if err != nil {
		log.Println("init error:", err)
	}
}

func GetAccessToken() (string, error) {
	url := "https://accounts.spotify.com/api/token"
	data := "grant_type=client_credentials"
	req, err := http.NewRequest("POST", url, bytes.NewBufferString(data))
	if err != nil {
		return "", err
	}

	req.Header.Add("Authorization", "Basic "+base64.StdEncoding.EncodeToString([]byte(clientId+":"+clientSecret)))
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var result map[string]interface{}
	err = json.Unmarshal(body, &result)
	if err != nil {
		return "", err
	}

	return result["access_token"].(string), nil
}

func GetPlaylistTracks() ([]models.Track, error) {
	var allTracks []models.Track
	rand.Seed(time.Now().UnixNano())
	min := 1
	max := 4035
	offset := rand.Intn(max-min+1) + min
	limit := 50
	url := fmt.Sprintf("https://api.spotify.com/v1/playlists/%s/tracks?offset=%d&limit=%d", playlistId, offset, limit)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Add("Authorization", "Bearer "+accessToken)
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	var result map[string]interface{}
	err = json.Unmarshal(body, &result)
	if err != nil {
		return nil, err
	}
	items := result["items"].([]interface{})
	maxRetries := 5
	for _, item := range items {
		track, ok := FromJson(item.(map[string]interface{}))
		if ok {
			allTracks = append(allTracks, track)
		}
	}
	if len(allTracks) == 0 {
		for attempt := 0; attempt < maxRetries; attempt++ {
			url = fmt.Sprintf("https://api.spotify.com/v1/playlists/%s/tracks?offset=%d&limit=%d", playlistId, offset, limit)
			req, err = http.NewRequest("GET", url, nil)
			if err != nil {
				return nil, err
			}
			req.Header.Add("Authorization", "Bearer "+accessToken)
			resp, err = client.Do(req)
			if err != nil {
				return nil, err
			}
			defer resp.Body.Close()
			body, err = ioutil.ReadAll(resp.Body)
			if err != nil {
				return nil, err
			}
			err = json.Unmarshal(body, &result)
			if err != nil {
				return nil, err
			}
			items = result["items"].([]interface{})
			for _, item := range items {
				track, ok := FromJson(item.(map[string]interface{}))
				if ok {
					allTracks = append(allTracks, track)
					break
				}
			}
			if len(allTracks) > 0 {
				break
			}
			time.Sleep(time.Second * 2)
		}
	}
	if len(allTracks) == 0 {
		return nil, fmt.Errorf("failed to fetch tracks after %d attempts", maxRetries)
	}
	return allTracks, nil
}

func GetRandomPlaylistTracks() ([]models.Track, error) {
	var count = 4
	allTracks, err := GetPlaylistTracks()
	if err != nil {
		return nil, err
	}

	if len(allTracks) < count {
		return nil, fmt.Errorf("not enough tracks in playlist to select %d random tracks", count)
	}

	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(allTracks), func(i, j int) { allTracks[i], allTracks[j] = allTracks[j], allTracks[i] })

	return allTracks[:count], nil
}

func FromJson(data map[string]interface{}) (models.Track, bool) {
	trackData := data["track"].(map[string]interface{})
	url, ok := trackData["preview_url"].(string)
	if !ok || url == "" {
		return models.Track{}, false
	}
	return models.Track{
		Title:    trackData["name"].(string),
		Url:      url,
		Artiste:  trackData["artists"].([]interface{})[0].(map[string]interface{})["name"].(string),
		ImageUrl: trackData["album"].(map[string]interface{})["images"].([]interface{})[0].(map[string]interface{})["url"].(string),
	}, true
}
